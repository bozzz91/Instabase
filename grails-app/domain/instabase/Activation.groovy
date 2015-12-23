package instabase

class Activation {

    static constraints = {
    }

    static belongsTo = [person: Person]

    Person person
    String code
    boolean done
}
