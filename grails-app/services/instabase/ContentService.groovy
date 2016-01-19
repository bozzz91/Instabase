package instabase
import grails.transaction.Transactional
import grails.util.Environment
import grails.util.Metadata
import org.springframework.web.multipart.commons.CommonsMultipartFile

@Transactional
class ContentService {

    private static String ROOT = '${root}'
    private static String VERSION = '_version_'
    private static String COST = '_cost_'
    private static String FREE = '_free_'

    private static String getStorageRoot() {
        Metadata.getCurrent().get('instabase.storage.root')
    }

    private static String getStorageInitRoot() {
        Metadata.getCurrent().get('instabase.storage.init.root')
    }

    private static String generateBaseDir(Base base) {
        String baseDir = ROOT + File.separator

        def folders = [base.name-'.txt']
        Node parent = base.parent
        while (parent) {
            Node node = Node.get(parent.id)
            folders << node.name
            parent = node.parent
        }

        folders.reverse().each {
            baseDir += it + File.separator
        }

        return baseDir
    }

    private static String generateVersion(Base base) {
        return base.cost > 0 ? "v${base.ver}.txt" : "free.txt"
    }

    void saveBaseFile(Base base, CommonsMultipartFile multipartFile) {
        if (!base.name) {
            base.name = multipartFile.originalFilename
        }
        String baseDir = generateBaseDir(base)
        File dir = new File(baseDir.replace(ROOT, getStorageRoot()))
        dir.mkdirs()
        File uploadedFile = new File(dir, generateVersion(base))
        multipartFile.transferTo(uploadedFile)
        base.filePath = baseDir
    }

    File getBaseFile(Base base, Person person) {
        def version = 'free'
        if (base.cost > 0 && person) {
            PersonBase pb = PersonBase.get(person.id, base.id)
            if (pb) {
                version = "v${pb.baseVersion}"
            } else if (SecUserSecRole.exists(SecRole.findByAuthority('ROLE_ADMIN').id, person.id)) {
                version = "v${base.ver}"
            }
        }

        String path = base.filePath + File.separator + "${version}" + '.txt'
        path = path.replace(ROOT, getStorageRoot())
        new File(path)
    }

    void initFromStorage() {
        String initRoot = getStorageInitRoot()
        String defaultCost = Metadata.getCurrent().getProperty("instabase.base.default.cost")
        File rootDir = new File(initRoot)
        rootDir.eachFileRecurse {
            if (it.isFile() && !it.name.split(VERSION)[0].endsWith('.txt')) {
                throw new Exception('wrong base name: ' + it.absolutePath)
            }
        }
        processFolder(rootDir, defaultCost)
        if (Environment.current == Environment.PRODUCTION) {
            rootDir.eachFile {
                if (it.isDirectory()) {
                    it.deleteDir()
                } else if (it.isFile()) {
                    it.delete()
                }
            }
        }
        recalculateNodes()
    }

    private void processFolder(File folder, String defCost, Node parent = null) {
        folder.listFiles().each { f ->
            if (f.isDirectory()) {
                int currentLevel = 0
                if (parent) {
                    currentLevel = parent.level + 1
                }
                def nodeName = f.name
                def nodeDefCost = defCost
                if (f.name.contains(COST)) {
                    nodeName    = f.name.split(COST)[0]
                    nodeDefCost = f.name.split(COST)[1]
                }
                Node node = Node.findByNameAndLevelAndParent(nodeName, currentLevel, parent) ?:
                        new Node(
                                name: nodeName,
                                level: currentLevel,
                                parent: parent
                        ).save(flush: true)
                parent?.addToNodes(node)?.save(flush: true)

                processFolder(f, nodeDefCost, node)
            } else {
                String fileName = f.getName()
                String baseName = fileName
                int version = 1
                double cost = defCost as Double
                if (fileName.contains(VERSION)) {
                    baseName = fileName.split(VERSION)[0]
                    version = fileName.split(VERSION)[1] as Integer
                }
                if (baseName.startsWith(FREE)) {
                    cost = 0
                    baseName = baseName - FREE
                }

                Base b = Base.findByNameAndLevelAndParent(baseName, parent.level + 1, parent)
                if (!b) {
                    b = new Base(
                            name: baseName,
                            ver: version,
                            level: parent.level + 1,
                            parent: parent,
                            cost: cost,
                            contentName: baseName
                    )
                    String path = generateBaseDir(b)
                    b.filePath = path
                    b.save()
                }

                parent.addToNodes(b).save(flush: true)

                //upload to storage
                File uploadedFile = new File(generateBaseDir(b).replace(ROOT, getStorageRoot()), generateVersion(b))
                uploadedFile.parentFile.mkdirs()
                uploadedFile.withOutputStream { out ->
                    out << f.newInputStream()
                }
            }
        }
    }

    public void recalculateNodes() {
        Node.list().findAll {!(it instanceof Base)}.each { node ->
            node.cost = 0
            node.totalBaseCount = 0
            node.save()
        }
        List<Node> roots = Node.findAllByLevel(0)
        roots.each { node ->
            recalculateOneNode(node)
        }
    }

    private Map recalculateOneNode(Node node) {
        if (node instanceof Base) {
            return [count: node.cost > 0.0d ? 1 : 0, cost: node.cost]
        } else {
            node.nodes.each { innerNode ->
                def res = recalculateOneNode(innerNode)
                node.cost += res.cost
                node.totalBaseCount += res.count
            }
            node.save(flush: true)
            return [count: node.totalBaseCount, cost: node.cost]
        }
    }

    public void updateBaseParents(Base base, Double costDiff, boolean isNew = false) {
        if (!isNew && costDiff < 0.000001) {
            return
        }
        def parentNode = base.parent
        while (parentNode) {
            parentNode.cost += costDiff
            if (isNew) {
                parentNode.totalBaseCount++
            }
            parentNode.save()
            parentNode = parentNode.parent
        }
    }
}
