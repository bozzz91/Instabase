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

    def index(String category) {
        if (!category) {
            category = session['category']
        }
        if (!category) {
            category = "Геолокация"
        }
        session['category'] = category
        render (view: 'index', model: [category: category])
    }

    @Transactional
    @Secured(['ROLE_USER'])
    def purchase() {
        Person p = springSecurityService.currentUser as Person
        def result = purchaseService.purchaseBases(params, p)
        render result
    }

    @Transactional
    @Secured(['ROLE_USER'])
    def upgrade() {
        Person p = springSecurityService.currentUser as Person
        def result = purchaseService.upgradeBases(params, p)
        render result
    }

    def generateFileList() {
        Person p = springSecurityService.currentUser as Person
        render generateNodeTreeService.generateTree(params, p)
    }

    @Secured(['ROLE_ADMIN'])
    def show(Node nodeInstance) {
        if (nodeInstance instanceof Base) {
            redirect (controller: 'base', action: 'show', id: nodeInstance.id)
        }
        respond nodeInstance
    }

    @Secured(['ROLE_ADMIN'])
    def create() {
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

        redirect controller: 'node', action: 'edit', id: nodeInstance.id, params: [parent: nodeInstance.parent.id]
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
                flash.message = message(code: 'default.updated.message', args: [message(code: 'node.label', default: 'Node'), nodeInstance.id])
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
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'node.label', default: 'Node'), nodeInstance.id])
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
