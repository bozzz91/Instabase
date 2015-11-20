package instabase

import grails.transaction.Transactional
import grails.util.Metadata

@Transactional
class PaymentService {

    def getSecret() {
        String path = Metadata.getCurrent().get("instabase.yandex.secret.file.path")
        return new File(path).text
    }
}
