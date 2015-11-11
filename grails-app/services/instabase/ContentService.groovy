package instabase
import grails.transaction.Transactional
import grails.util.Metadata
import org.springframework.web.multipart.commons.CommonsMultipartFile

@Transactional
class ContentService {

    private static String getStorageRoot() {
        String path = Metadata.getCurrent().get('instabase.storage.root')
        path
    }

    private static File generateBaseDir(Base base) {
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

    void saveBaseFile(Base base, CommonsMultipartFile multipartFile) {
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
