package instabase

class Payment {

    static constraints = {
        owner(nullable: false)
        amount(nullable: false, min: 0.0d)
        creationDate()
        payDate()
        state()
    }

    enum State {
        WAIT("Ожидается оплата"),
        DONE("Принят"),
        ERROR("Ошибка")

        final String value

        State(String value) {
            this.value = value
        }

        String toString() { value }
        String getKey() { name() }
    }

    static belongsTo = [owner: Person]

    Double amount
    Date creationDate
    Date payDate
    Person owner
    State state = State.WAIT
}
