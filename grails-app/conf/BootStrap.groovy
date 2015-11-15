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
                enabled: true).save(failOnError: true)

        if (!user.authorities.contains(userRole)) {
            SecUserSecRole.create user, userRole
        }

        Node root = new Node(name: 'Instagram', type: 'root').save();
        Node country = new Node(name: 'Россия', type: 'Страна', parent: root).save();
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
    }

    def destroy = {
    }
}
