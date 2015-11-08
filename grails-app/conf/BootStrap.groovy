import instabase.*

class BootStrap {

    def init = { servletContext ->
        Role role = new Role(name: 'admin').save()
        new Person(email: 'abc@asb.com', login: 'admin', password: 'admin', cash: 100.0d, fullName: 'admin', role: role).save()
        Node root = new Node(name: 'Instagram', type: 'root').save();
        Node country = new Node(name: 'Россия', type: 'Страна', parent: root).save();
        Node region1 = new Node(name: 'РБ', type: 'Регион', parent: country).save();
        Node ufa = new Node(name: 'Уфа', type: 'Город', parent: region1).save();
        new Node(name: 'Чишмы', type: 'Город', parent: region1).save();
        Node region2 = new Node(name: 'Московская обл', type: 'Регион', parent: country).save();
        Node msc = new Node(name: 'Москва', type: 'Город', parent: region2).save();

        Base base1 = new Base(name: 'base 1', type: 'База', parent: ufa, ver: 1, content: new byte[1]).save();
        Base base2 = new Base(name: 'base 2', type: 'База', parent: msc, ver: 1, content: new byte[1]).save();
    }

    def destroy = {
    }
}
