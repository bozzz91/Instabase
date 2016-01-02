package instabase

class Base extends Node {

    static constraints = {
        creationDate(nullable: true)
        updateDate(nullable: true)
        ver(nullable: false, min: 1)
        filePath(nullable: false)
        contentName(nullable: true)
        length(nullable: false, min: 0l, max: 100000000l)
    }

    Integer ver = 1
    Date creationDate
    Date updateDate
    String filePath
    Long length = 0l
    String contentName = "unknown"

    def beforeInsert() {
        super.beforeInsert()
        creationDate = new Date()
        updateDate = creationDate
    }

    def beforeUpdate() {
        super.beforeUpdate()
        updateDate = new Date()
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
        "База - ${name}[id=$id, level=$level]"
    }
}
