package instabase

class Person extends SecUser {

    static constraints = {
        fullName(nullable: true)
        cash(nullable: false, blank: false, min: 0.0d)
        created(nullable: true)
    }

    static hasMany = [payments: Payment]

    String fullName
    Date created
    Double cash = 0.0d

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
