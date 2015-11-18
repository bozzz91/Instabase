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
    def mailService

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
        render generateNodeTreeService.generateTree(params, user, true)
    }

    @Secured(['ROLE_USER'])
    def show(Person personInstance) {
        respond personInstance
    }

    private static boolean hasAccessToPerson(Person current, Person p) {
        def hasAccess = false
        hasAccess = hasAccess || current.id == p.id
        hasAccess = hasAccess || SecUserSecRole.where { secUser == current && secRole.authority == 'ROLE_ADMIN' }.count() > 0
        hasAccess
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

        if (params.password != params.confirmPassword) {
            flash.message = 'Не совпадают пароли!'
            respond personInstance.errors, view: 'create'
            return
        }

        personInstance.save flush: true
        String code = springSecurityService.encodePassword(personInstance.username, null)
        def activation = new Activation(
                code: code,
                done: false,
                person: personInstance
        )
        activation.save()

        mailService.sendMail {
            to personInstance.username
            subject "Account activation"
            body "your code ${code}"
        }
        log.info("your code ${code}")

        render (view: 'success', model: ['text': "Activation link was sent on ${personInstance.username}"])
    }

    @Transactional
    @Secured(['IS_AUTHENTICATED_ANONYMOUSLY'])
    def activate() {
        String activateCode = params.activateCode
        if (!activateCode) {
            render(view: 'error', model: ['text': "Wrong activation code"])
        } else {
            def activation = Activation.findAllByCodeAndDone(activateCode, false).max { it.id }
            if (activation) {
                activation.done = true
                activation.save()
                activation.person.enabled = true
                activation.person.save()
                render(view: 'success', model: ['text': "Activation success!"])
            } else {
                render(view: 'error', model: ['text': "Wrong activation code"])
            }
        }
    }

    @Secured(['ROLE_USER'])
    def edit(Person personInstance) {
        Person user = springSecurityService.currentUser as Person
        if (hasAccessToPerson(user, personInstance)) {
            respond personInstance
        } else {
            render(status: FORBIDDEN, view: 'error', model: [text: 'You can not edit other accounts.'])
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
        if (!hasAccessToPerson(user, personInstance)) {
            render(status: FORBIDDEN, view: 'error', model: [text: 'You can not update other accounts.'])
        } else {
            if (personInstance.hasErrors()) {
                respond personInstance.errors, view: 'edit'
                return
            }

            Activation.where { person == personInstance }.deleteAll()
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
