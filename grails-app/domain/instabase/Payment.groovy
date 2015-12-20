package instabase

class Payment {

    static constraints = {
        owner(nullable: false)
        amount(nullable: false, min: 0.0d)
        creationDate(nullable: true)
        payDate(nullable: true)
        state()
        operationId(nullable: true)
    }

    enum State {
        WAIT("Ожидается оплата"),
        PROCESS("Обрабатывается"),
        DONE("Принят"),
        ERROR("Ошибка"),
        DELETE("Ожидает удаления")

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
    String operationId

    def beforeInsert() {
        creationDate = new Date()
    }
}
