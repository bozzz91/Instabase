package instabase

import grails.plugin.springsecurity.annotation.Secured

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional

@Secured(['IS_AUTHENTICATED_ANONYMOUSLY'])
@Transactional(readOnly = true)
class NodeController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def purchaseService
    def generateNodeTreeService
    def springSecurityService

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        render (view: 'index')
    }

    @Transactional
    @Secured(['ROLE_USER'])
    def purchase() {
        String ids = params.ids
        Person p = springSecurityService.currentUser as Person
        def result = purchaseService.purchaseBases(ids, p)
        render result
    }

    def generateFileList() {
        render generateNodeTreeService.generateTree(params.nodeId as String)
    }

    @Secured(['ROLE_ADMIN'])
    def show(Node nodeInstance) {
        if (nodeInstance instanceof Base) {
            redirect ([controller: 'base', action: 'show', params: [id: nodeInstance.id]])
        }
        respond nodeInstance
    }

    @Secured(['ROLE_ADMIN'])
    def create() {
        def type = params.type
        if (!type) {
            def parentId = params.node?.id as Long
            if (parentId) {
                Node parent = Node.get(parentId as Long)
                type = parent.type
            }
        }
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
    @Secured(['ROLE_ADMIN'])
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

    @Secured(['ROLE_ADMIN'])
    def edit(Node nodeInstance) {
        respond nodeInstance
    }

    @Transactional
    @Secured(['ROLE_ADMIN'])
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
    @Secured(['ROLE_ADMIN'])
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
