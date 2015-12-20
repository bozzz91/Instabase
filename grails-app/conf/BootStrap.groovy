import grails.util.Environment
import grails.util.Metadata
import instabase.*

class BootStrap {

    def init = { def servletContext ->
        SecRole adminRole = SecRole.findByAuthority('ROLE_ADMIN') ?: new SecRole(authority: 'ROLE_ADMIN').save(failOnError: true)
        SecRole userRole = SecRole.findByAuthority('ROLE_USER') ?: new SecRole(authority: 'ROLE_USER').save(failOnError: true)

        Person adminUser = Person.findByUsername('admin@instabase.su') ?: new Person(
                cash: 100.0d, fullName: 'Instabase Admin',
                username: 'admin@instabase.su',
                password: 'admin',
                enabled: true).save(failOnError: true)

        if (!adminUser.authorities.contains(adminRole)) {
            SecUserSecRole.create adminUser, adminRole
        }

        File root = new File(Metadata.getCurrent().getProperty("instabase.storage.root"))
        root.mkdirs()

        if (Environment.current == Environment.DEVELOPMENT) {
            Person user = Person.findByUsername('user@user.com') ?: new Person(
                    cash: 0.0d, fullName: 'user',
                    username: 'user@user.com',
                    password: 'user',
                    enabled: false).save(failOnError: true)
            def activation = new Activation(
                    code: '123',
                    done: false,
                    person: user
            )
            activation.save()

            if (!user.authorities.contains(userRole)) {
                SecUserSecRole.create user, userRole
            }

            Node root1 = new Node(name: 'Instagram').save();
            Node country = new Node(name: 'Россия', parent: root1).save();
            Node region1 = new Node(name: 'РБ', parent: country).save();
            Node ufa = new Node(name: 'Уфа', parent: region1).save();
            Node chs = new Node(name: 'Чишмы', parent: region1).save();
            Node region2 = new Node(name: 'Московская обл', parent: country).save();
            Node msc = new Node(name: 'Москва', parent: region2).save();

            Base base1 = new Base(name: 'base 1', parent: ufa, ver: 1, filePath: 'sdf', contentName: 'name1').save();
            Base base2 = new Base(name: 'base 2', parent: msc, ver: 1, filePath: 'sdfsf', contentName: 'name2').save();
            Base base3 = new Base(name: 'base 3', parent: chs, ver: 1, filePath: 'sdfsdfsdf', contentName: 'name3').save();

            PersonBase.create(adminUser, base1)
            PersonBase.create(adminUser, base2)

            PersonBase.create(user, base2)
            PersonBase.create(user, base3)

            Node root2 = new Node(name: 'VK').save();
            Node country2 = new Node(name: 'Россия', parent: root2).save();
            Node region3 = new Node(name: 'Татарстан', parent: country2).save();
            Node kazan = new Node(name: 'Казань', parent: region3).save();
            Node nij = new Node(name: 'Нижнекамск', parent: region3).save();
            Node region4 = new Node(name: 'Самарская обл', parent: country2).save();
            Node samara = new Node(name: 'Самара', parent: region4).save();

            Base base4 = new Base(name: 'base 4', parent: kazan, ver: 1, filePath: 'sdf', contentName: 'name1').save();
            Base base5 = new Base(name: 'base 5', parent: nij, ver: 1, filePath: 'sdfsf', contentName: 'name2').save();
            Base base6 = new Base(name: 'base 6', parent: samara, ver: 1, filePath: 'sdfsdfsdf', contentName: 'name3').save();

            PersonBase.create(adminUser, base4)
            PersonBase.create(adminUser, base5)

            PersonBase.create(user, base5)
            PersonBase.create(user, base6)

            new Payment(state: Payment.State.WAIT, amount: 10d, owner: user).save()
        }
    }

    def destroy = {
    }
}
