package instabase

class Node {

    static constraints = {
        name(nullable: false, blank: false)
        type(nullable: false, inList: ['Group','Country','Region','Town'])
        parent(nullable: true)
    }

    static hasMany = [nodes: Node, bases: Base]
    static belongsTo = [parent: Node]

    Node parent

    String name
    String type = 'G'

    @Override
    String toString() {
        name
    }
}
