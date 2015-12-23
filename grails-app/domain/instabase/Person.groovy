package instabase

class Person extends SecUser {

    static constraints = {
        fullName(nullable: true)
        cash(nullable: false, blank: false, min: 0.0d)
        created(nullable: true)
    }

    static hasMany = [payments: Payment, activations: Activation]

    static mapping = {
        payments cascade: 'all-delete-orphan'
        activations cascade: 'all-delete-orphan'
    }

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
