package instabase

class Node {

    static constraints = {
        name(nullable: false, blank: false)
        type(nullable: false, inList: ['root','Страна','Регион','Город', 'Категория', 'База'])
        parent(nullable: true)
    }

    static hasMany = [nodes: Node, bases: Base]
    static belongsTo = [parent: Node]

    Node parent

    String name
    String type

    boolean isEmpty() {
        nodes?.isEmpty() && bases?.isEmpty()
    }

    @Override
    String toString() {
        "Узел - $name"
    }
}
