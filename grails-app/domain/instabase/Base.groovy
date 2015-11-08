package instabase

class Base extends Node {

    static constraints = {
        creationDate(nullable: true)
        cost(nullable: false, min: 0.0d)
        ver(nullable: false, min: 1)
        content(nullable: false, maxSize: 5*1024*1024)
        contentName(nullable: true)
    }

    static mapping = {}

    Integer ver
    Date creationDate
    Double cost = 1.0d
    byte[] content
    String contentName = "unknown"

    def beforeInsert() {
        creationDate = new Date()
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
