package instabase

class Base extends Node {

    static constraints = {
        creationDate(nullable: true)
        cost(nullable: false, min: 0.0d)
        ver(nullable: false, min: 1)
        filePath(nullable: false)
        contentName(nullable: true)
        length(nullable: false, min: 0l, max: 5000000l)
    }

    Integer ver
    Date creationDate
    Double cost = 1.0d
    String filePath
    Long length = 0l
    String contentName = "unknown"

    def beforeInsert() {
        creationDate = new Date()
    }

    def beforeDelete() {
        /*Base.withSession {
            PersonBase.removeAll(this, true)
        }*/
    }

    def afterDelete() {
        if (filePath) {
            File upload = new File(filePath)
            if (upload.exists()) {
                upload.delete()
            }
        }
    }

    @Override
    boolean isEmpty() {
        true
    }

    @Override
    String toString() {
        "База - $name"
    }
}
