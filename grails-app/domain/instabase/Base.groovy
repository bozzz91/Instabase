package instabase

class Base extends Node {

    static constraints = {
        creationDate(nullable: true)
    }

    Integer ver
    Date creationDate

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
