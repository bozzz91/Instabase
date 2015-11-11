package instabase
import grails.transaction.Transactional
import grails.util.Holders
import org.springframework.web.multipart.commons.CommonsMultipartFile

@Transactional
class ContentService {

    def grailsApplication = Holders.getGrailsApplication()

    private String getStorageRoot() {
        String path = grailsApplication.config.instabase.storage.root
        path
    }

    private File generateBaseDir(Base base) {
        String root = getStorageRoot()
        String s = File.separator
        String baseDir = root

        def deque = []
        deque << (base.ver as String)
        deque << base.name
        Node parent = base.parent
        while (parent) {
            Node node = Node.get(parent.id)
            deque << node.name
            parent = node.parent
        }

        deque.reverse().each {
            baseDir += it + s
        }

        return new File(baseDir)
    }

    def saveBaseFile(Base base, CommonsMultipartFile multipartFile) {
        File dir = generateBaseDir(base)
        dir.mkdirs()
        File uploadedFile = new File(dir, multipartFile.originalFilename)
        multipartFile.transferTo(uploadedFile)
        base.filePath = uploadedFile.absolutePath
    }

    File getBaseFile(Base base) {
        new File(base.filePath)
    }
}
