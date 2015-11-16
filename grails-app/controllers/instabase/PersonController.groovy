package instabase

import grails.plugin.springsecurity.annotation.Secured

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional

@Secured(['ROLE_ADMIN'])
@Transactional(readOnly = true)
class PersonController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def generateNodeTreeService
    def springSecurityService

    @Secured(['ROLE_USER'])
    def index() {
        String category = params.category ?: "Instagram"
        render (view: 'index', model: [category: category])
    }

    def list() {
        respond Person.list(params), model: [personInstanceCount: Person.count()]
    }

    @Secured(['ROLE_USER'])
    def generateFileList() {
        Person user = springSecurityService.currentUser as Person
        render generateNodeTreeService.generateTree(params, user)
    }

    @Secured(['ROLE_USER'])
    def show(Person personInstance) {
        respond personInstance
    }

    @Secured(['IS_AUTHENTICATED_ANONYMOUSLY'])
    def create() {
        Person user = springSecurityService.currentUser as Person
        if (!springSecurityService.isLoggedIn() || user?.authorities?.any{ it.authority == 'ROLE_ADMIN'}) {
            respond new Person(params)
        } else {
            redirect action: 'index'
        }
    }

    @Transactional
    @Secured(['IS_AUTHENTICATED_ANONYMOUSLY'])
    def save(Person personInstance) {
        if (personInstance == null) {
            notFound()
            return
        }

        if (personInstance.hasErrors()) {
            respond personInstance.errors, view: 'create'
            return
        }

        personInstance.save flush: true

        /*request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'person.label', default: 'Person'), personInstance.id])
                redirect personInstance
            }
            '*' { respond personInstance, [status: CREATED] }
        }*/
        //TODO send activation on email
        render (view: 'success', model: ['text': "Activation link was sent on ${personInstance.email}"])
    }

    @Transactional
    @Secured(['IS_AUTHENTICATED_ANONYMOUSLY'])
    def activate() {
        String activateHash = params.activateHash
        if (!activateHash) {
            render(view: 'error', model: ['text': "Wrong activation hash"])
        } else {
            //todo find activation in DB
            render(view: 'success', model: ['text': "Activation success!"])
        }
    }

    @Secured(['ROLE_USER'])
    def edit(Person personInstance) {
        Person user = springSecurityService.currentUser as Person
        if (!user.authorities.contains('ROLE_ADMIN')) {
            render(status: FORBIDDEN, view: 'error', model: [text: 'You can not edit other accounts.'])
        } else {
            respond personInstance
        }
    }

    @Transactional
    @Secured(['ROLE_USER'])
    def update(Person personInstance) {
        if (personInstance == null) {
            notFound()
            return
        }

        Person user = springSecurityService.currentUser as Person
        if (!user.authorities.contains('ROLE_ADMIN')) {
            render(status: FORBIDDEN, view: 'error', model: [text: 'You can not update other accounts.'])
        } else {
            if (personInstance.hasErrors()) {
                respond personInstance.errors, view: 'edit'
                return
            }

            personInstance.save flush: true

            request.withFormat {
                form multipartForm {
                    flash.message = message(code: 'default.updated.message', args: [message(code: 'Person.label', default: 'Person'), personInstance.id])
                    redirect personInstance
                }
                '*' { respond personInstance, [status: OK] }
            }
        }
    }

    @Transactional
    def delete(Person personInstance) {

        if (personInstance == null) {
            notFound()
            return
        }

        personInstance.delete flush: true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'Person.label', default: 'Person'), personInstance.id])
                redirect action: "index", method: "GET"
            }
            '*' { render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'person.label', default: 'Person'), params.id])
                redirect action: "index", method: "GET"
            }
            '*' { render status: NOT_FOUND }
        }
    }
}
