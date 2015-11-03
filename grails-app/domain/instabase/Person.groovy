package instabase

class Person {

    static constraints = {
        login(nullable: false, blank: false)
        password(nullable: false, blank: false)
        fullName(nullable: false, blank: false)
        cash(nullable: false, blank: false)
        role(nullable: false)
        created(nullable: true)
    }
    static hasMany = [bases: Base]

    Role role

    String login
    String password
    String fullName
    Date created
    Double cash

    def beforeInsert() {
        created = new Date()
        cash = 0.0
    }

    String toString() {
        fullName
    }
}
