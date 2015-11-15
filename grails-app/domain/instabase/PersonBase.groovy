package instabase

import org.apache.commons.lang.builder.HashCodeBuilder

@SuppressWarnings("UnnecessaryQualifiedReference")
class PersonBase implements Serializable {

    Person person
    Base base
    Integer baseVersion

    boolean equals(other) {
        if (!(other instanceof PersonBase)) {
            return false
        }

        other.person?.id == person?.id &&
                other.base?.id == base?.id
    }

    int hashCode() {
        def builder = new HashCodeBuilder()
        if (person) builder.append(person.id)
        if (base) builder.append(base.id)
        builder.toHashCode()
    }

    static PersonBase get(long personId, long baseId) {
        PersonBase.where {
            person == Person.load(personId) &&
                    base == Base.load(baseId)
        }.get()
    }

    static boolean exists(long personId, long baseId) {
        PersonBase.where {
            person == Person.load(personId) &&
                    base == Base.load(baseId)
        }.count() > 0
    }

    static PersonBase create(Person person, Base base, boolean flush = false) {
        def instance = new PersonBase(person: person, base: base, baseVersion: base.ver)
        instance.save(flush: flush, insert: true)
        instance
    }

    static boolean remove(Person u, Base r, boolean flush = false) {
        if (u == null || r == null) return false

        int rowCount = PersonBase.where {
            person == Person.load(u.id) &&
                    base == Base.load(r.id)
        }.deleteAll()

        if (flush) { PersonBase.withSession { it.flush() } }

        rowCount > 0
    }

    static void removeAll(Person u, boolean flush = false) {
        if (u == null) return

        PersonBase.where {
            person == Person.load(u.id)
        }.deleteAll()

        if (flush) { PersonBase.withSession { it.flush() } }
    }

    static void removeAll(Base r, boolean flush = false) {
        if (r == null) return

        PersonBase.where {
            base == Base.load(r.id)
        }.deleteAll()

        if (flush) { PersonBase.withSession { it.flush() } }
    }

    static constraints = {
        base validator: { Base r, PersonBase ur ->
            if (ur.person == null) return
            boolean existing = false
            PersonBase.withNewSession {
                existing = PersonBase.exists(ur.person.id, r.id)
            }
            if (existing) {
                return 'personBase.exists'
            }
        }
        baseVersion(nullable: false, min: 1)
    }

    static mapping = {
        id composite: ['base', 'person']
        version false
    }
}
