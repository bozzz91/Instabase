import instabase.*

class BootStrap {

    def init = { servletContext ->
        SecRole userRole = SecRole.findByAuthority('ROLE_USER') ?: new SecRole(authority: 'ROLE_USER').save(failOnError: true)
        SecRole adminRole = SecRole.findByAuthority('ROLE_ADMIN') ?: new SecRole(authority: 'ROLE_ADMIN').save(failOnError: true)
        
        Person adminUser = SecUser.findByUsername('admin') ?: new Person(
                email: 'admin@asb.com', cash: 100.0d, fullName: 'admin',
                username: 'admin',
                password: 'admin',
                enabled: true).save(failOnError: true)

        if (!adminUser.authorities.contains(adminRole)) {
            SecUserSecRole.create adminUser, adminRole
        }

        Person user = SecUser.findByUsername('user') ?: new Person(
                email: 'user@asb.com', cash: 100.0d, fullName: 'user',
                username: 'user',
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

        Node root1 = new Node(name: 'Instagram', type: 'root').save();
        Node country = new Node(name: 'Россия', type: 'Страна', parent: root1).save();
        Node region1 = new Node(name: 'РБ', type: 'Регион', parent: country).save();
        Node ufa = new Node(name: 'Уфа', type: 'Город', parent: region1).save();
        Node chs = new Node(name: 'Чишмы', type: 'Город', parent: region1).save();
        Node region2 = new Node(name: 'Московская обл', type: 'Регион', parent: country).save();
        Node msc = new Node(name: 'Москва', type: 'Город', parent: region2).save();

        Base base1 = new Base(name: 'base 1', type: 'База', parent: ufa, ver: 1, filePath: 'sdf', contentName: 'name1').save();
        Base base2 = new Base(name: 'base 2', type: 'База', parent: msc, ver: 1, filePath: 'sdfsf', contentName: 'name2').save();
        Base base3 = new Base(name: 'base 3', type: 'База', parent: chs, ver: 1, filePath: 'sdfsdfsdf', contentName: 'name3').save();

        PersonBase.create(adminUser, base1)
        PersonBase.create(adminUser, base2)

        PersonBase.create(user, base2)
        PersonBase.create(user, base3)

        Node root2 = new Node(name: 'VK', type: 'root').save();
        Node country2 = new Node(name: 'Россия', type: 'Страна', parent: root2).save();
        Node region3 = new Node(name: 'Татарстан', type: 'Регион', parent: country2).save();
        Node kazan = new Node(name: 'Казань', type: 'Город', parent: region3).save();
        Node nij = new Node(name: 'Нижнекамск', type: 'Город', parent: region3).save();
        Node region4 = new Node(name: 'Самарская обл', type: 'Регион', parent: country2).save();
        Node samara = new Node(name: 'Самара', type: 'Город', parent: region4).save();

        Base base4 = new Base(name: 'base 4', type: 'База', parent: kazan, ver: 1, filePath: 'sdf', contentName: 'name1').save();
        Base base5 = new Base(name: 'base 5', type: 'База', parent: nij, ver: 1, filePath: 'sdfsf', contentName: 'name2').save();
        Base base6 = new Base(name: 'base 6', type: 'База', parent: samara, ver: 1, filePath: 'sdfsdfsdf', contentName: 'name3').save();

        PersonBase.create(adminUser, base4)
        PersonBase.create(adminUser, base5)

        PersonBase.create(user, base5)
        PersonBase.create(user, base6)
    }

    def destroy = {
    }
}
