package instabase

import grails.converters.JSON

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional

@Transactional(readOnly = true)
class NodeController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        render (view: 'index')
    }

    def purchase = {
        String ids = params.ids
        Person p = Person.findByLogin('admin')
        def bases = [] as Set
        ids.split(',').each {
            if (it.startsWith('node_')) {
                Node node = Node.findById(it.substring(5) as Long)
                node.bases.each { base ->
                    bases << base.id
                }
                node.nodes.each {}
            } else if (it.startsWith('base_')) {
                Base base = Base.findById(it.substring(5) as Long)
                bases << base.id
            }
        }.each {
            p.addToBases(Base.findById(it))
        }
        p.save();
        render "OK"
    }

    def collectBasesFromNode = { Node node ->
        node.bases.each { base ->
            bases << base.id
        }
    }

    def generateFileList = {
        String nodeId = params.nodeId
        if (!nodeId || nodeId == "#") {
            render nodesToJson(Node.findAll("from Node n where n.type = 'root'"))
            return
        }
        Node currentNode = Node.get(nodeId.substring(5) as Integer)
        Set<Node> nodes = currentNode.nodes
        Set<Node> bases = currentNode.bases

        if (nodes) {
            nodes = nodes.sort { it.name }
        }
        if (bases) {
            bases = bases.sort { it.name }
        }
        bases.each {
            nodes << it
        }

        render nodesToJson(nodes)
    }

    def nodesToJson = { def nodes ->
        if (!nodes) {
            return ([] as JSON)
        }
        List result = []
        nodes.each {
            result << nodeToJson(it as Node)
        }
        return (result as JSON)
    }

    def nodeToJson = { Node node ->
        def idPrefix = 'node_'
        def icon = createLinkTo(dir: 'images', file: 'folder.png')
        if (node instanceof Base) {
            idPrefix = 'base_'
            icon = createLinkTo(dir: 'images', file: 'db.png')
        }
        return [
                id: idPrefix + node.id,
                text: node.name,
                state : [
                    'opened' : false,
                    'selected' : false
                ],
                icon: icon,
                children: !node.isEmpty(),
        ]
    }

    def show(Node nodeInstance) {
        respond nodeInstance
    }

    def create() {
        def type = params.type
        switch (type) {
            case 'root': type = 'Страна'; break;
            case 'Страна': type = 'Регион'; break;
            case 'Регион': type = 'Город'; break;
            case 'Город': type = 'Категория'; break;
        }
        params.type = type
        respond new Node(params)
    }

    @Transactional
    def save(Node nodeInstance) {
        if (nodeInstance == null) {
            notFound()
            return
        }

        if (nodeInstance.hasErrors()) {
            respond nodeInstance.errors, view:'create'
            return
        }

        nodeInstance.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'node.label', default: 'Node'), nodeInstance.id])
                redirect nodeInstance
            }
            '*' { respond nodeInstance, [status: CREATED] }
        }
    }

    def edit(Node nodeInstance) {
        respond nodeInstance
    }

    @Transactional
    def update(Node nodeInstance) {
        if (nodeInstance == null) {
            notFound()
            return
        }

        if (nodeInstance.hasErrors()) {
            respond nodeInstance.errors, view:'edit'
            return
        }

        nodeInstance.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'Node.label', default: 'Node'), nodeInstance.id])
                redirect nodeInstance
            }
            '*'{ respond nodeInstance, [status: OK] }
        }
    }

    @Transactional
    def delete(Node nodeInstance) {

        if (nodeInstance == null) {
            notFound()
            return
        }

        nodeInstance.delete flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'Node.label', default: 'Node'), nodeInstance.id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'node.label', default: 'Node'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
