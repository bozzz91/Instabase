package instabase
import grails.transaction.Transactional
import grails.util.Metadata
import org.springframework.web.multipart.commons.CommonsMultipartFile

@Transactional
class ContentService {

    private static String ROOT = '${root}'
    private static String VERSION = '_version_'

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
        File rootDir = new File(root)
        processFolder(rootDir)
    }

    private void processFolder(File folder, Node parent = null) {
        folder.listFiles().each { f ->
            if (f.isDirectory()) {
                int currentLevel = 0
                if (parent) {
                    currentLevel = parent.level + 1
                }
                Node node = Node.findByNameAndLevelAndParent(f.name, currentLevel, parent) ?:
                        new Node(
                                name: f.name,
                                level: currentLevel,
                                parent: parent
                        ).save()

                processFolder(f, node)
            } else {
                String fileName = f.getName()
                String baseName = fileName
                int version = 1
                if (fileName.contains(VERSION)) {
                    baseName = fileName.split(VERSION)[0]
                    version = fileName.split(VERSION)[1] as Integer
                }
                Base.findByNameAndLevelAndVerAndParent(baseName, parent.level + 1, version, parent) ?:
                        new Base(
                            name: baseName,
                            ver: version,
                            level: parent.level + 1,
                            parent: parent,
                            cost: Metadata.getCurrent().get("instabase.base.default.cost") as Double,
                            contentName: baseName,
                            filePath: f.absolutePath.replace(getStorageRoot(), ROOT)
                        ).save()
            }
        }
    }
}
