package instabase

class Person {

    static constraints = {}
    static hasMany = [bases: Base]

    Role role

    String login
    String password
    String fullName
    Date created
    Double cash
}
