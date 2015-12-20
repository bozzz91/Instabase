package instabase

import grails.util.Metadata

class PaymentService {

    def getSecret() {
        String path = Metadata.getCurrent().get("instabase.yandex.secret.file.path")
        Properties props = new Properties()
        File propsFile = new File(path)
        props.load(propsFile.newDataInputStream())
        return props
    }
}
