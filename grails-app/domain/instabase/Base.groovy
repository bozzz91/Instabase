package instabase

class Base {

    static constraints = {}
    static belongsTo = [node: Node]

    Node node

    String name
    Integer ver
}
