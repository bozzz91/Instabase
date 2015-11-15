package instabase

class Person extends SecUser {

    static constraints = {
        email(email: true, blank: false)
        fullName(nullable: false, blank: false)
        cash(nullable: false, blank: false, min: 0.0d)
        created(nullable: true)
    }

    static hasMany = [payments: Payment]

    String email
    String fullName
    Date created
    Double cash

    Set<Base> getBases() {
        PersonBase.findAllByPerson(this).collect { it.base }
    }

    @Override
    def beforeInsert() {
        super.beforeInsert()
        created = new Date()
        if (!cash) {
            cash = 0.0
        }
    }

    @Override
    String toString() {
        fullName
    }
}
