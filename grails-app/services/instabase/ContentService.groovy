package instabase
import grails.transaction.Transactional
import grails.util.Metadata
import org.springframework.web.multipart.commons.CommonsMultipartFile

@Transactional
class ContentService {

    private static String ROOT = '${root}'
    private static String VERSION = '_version_'
    private static String COST = '_cost_'

    private static String getStorageRoot() {
        String path = Metadata.getCurrent().get('instabase.storage.root')
        path
    }

    private static String generateBaseDir(Base base) {
        String baseDir = ROOT + File.separator

        def folders = []
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

    void saveBaseFile(Base base, CommonsMultipartFile multipartFile) {
        String path = generateBaseDir(base)

        File dir = new File(path.replace(ROOT, getStorageRoot()))
        dir.mkdirs()
        String fileName = multipartFile.originalFilename + VERSION + base.ver
        File uploadedFile = new File(dir, fileName)
        multipartFile.transferTo(uploadedFile)
        base.filePath = path + File.separator + fileName
    }

    File getBaseFile(Base base) {
        String path = base.filePath
        path = path.replace(ROOT, getStorageRoot())
        new File(path)
    }

    void initFromStorage() {
        String root = getStorageRoot()
        String defaultCost = Metadata.getCurrent().getProperty("instabase.base.default.cost")
        File rootDir = new File(root)
        processFolder(rootDir, defaultCost)
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
                if (fileName.contains(VERSION)) {
                    baseName = fileName.split(VERSION)[0]
                    version = fileName.split(VERSION)[1] as Integer
                }
                Base b = Base.findByNameAndLevelAndParent(baseName, parent.level + 1, parent) ?:
                        new Base(
                            name: baseName,
                            ver: version,
                            level: parent.level + 1,
                            parent: parent,
                            cost: defCost as Double,
                            contentName: baseName,
                            filePath: f.absolutePath.replace(getStorageRoot(), ROOT)
                        ).save()
                parent.addToNodes(b).save(flush: true)
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
