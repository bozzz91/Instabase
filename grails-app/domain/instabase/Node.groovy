package instabase

class Node {

    static constraints = {
        name(nullable: false, blank: false)
        level(nullable: false, min: 0)
        parent(nullable: true)
        cost(nullable: false, min: 0.0d)
        totalBaseCount(nullable: false, min: 0)
    }

    static hasMany = [nodes: Node]
    static belongsTo = [parent: Node]

    Node parent
    String name
    Integer level = 0
    Double cost = 0.0d
    Integer totalBaseCount = 0

    boolean isEmpty() {
        nodes?.isEmpty()
    }

    def beforeInsert() {
        calcLevel()
    }

    def beforeUpdate() {
        calcLevel()
    }

    private void calcLevel() {
        if (parent) {
            this.level = parent.level +1
        }
    }

    @Override
    String toString() {
        "Узел - ${name}[id=$id, level=$level]"
    }
}
