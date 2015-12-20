package instabase

import grails.util.Metadata

class PaymentService {

    def getSecret() {
        String path = Metadata.getCurrent().get("instabase.yandex.secret.file.path")
        return new File(path).text
    }
}
