package instabase
import grails.plugin.springsecurity.annotation.Secured
import grails.transaction.Transactional
import org.codehaus.groovy.grails.web.mapping.LinkGenerator
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.context.SecurityContextHolder

import static org.springframework.http.HttpStatus.*

@Secured(['ROLE_ADMIN'])
@Transactional(readOnly = true)
class PersonController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    LinkGenerator grailsLinkGenerator
    def generateNodeTreeService
    def springSecurityService
    def authenticationManager
    def mailService

    @Secured(['ROLE_USER'])
    def index(String category) {
        if (!category) {
            category = session['category']
        }
        if (!category) {
            category = "Геолокация"
        }
        session['category'] = category
        render (view: 'index', model: [category: category, free: false])
    }

    @Secured(['IS_AUTHENTICATED_ANONYMOUSLY'])
    def free(String category) {
        if (!category) {
            category = session['category']
        }
        if (!category) {
            category = "Геолокация"
        }
        session['category'] = category
        render (view: 'index', model: [category: category, free: true])
    }

    def list() {
        if (!params.sort) {
            params.sort = 'created'
        }
        if (!params.order) {
            params.order = 'desc'
        }
        params.max = 25
        respond Person.list(params), model: [personInstanceCount: Person.count()]
    }

    @Secured(['IS_AUTHENTICATED_ANONYMOUSLY'])
    def generateFileList(boolean free) {
        Person user = springSecurityService.currentUser as Person
        render generateNodeTreeService.generateTree(params, user, true, free)
    }

    @Secured(['ROLE_USER'])
    def show(Person personInstance) {
        if (hasAccessToPerson(personInstance)) {
            def payments = personInstance.payments.findAll {
                it.state != Payment.State.DELETE
            }.sort {
                it.id
            }
            respond personInstance, model: [payments: payments]
        } else {
            render(status: FORBIDDEN, view: 'error', model: [text: 'You can not view other accounts.'])
        }
    }

    private boolean hasAccessToPerson(Person p) {
        Person currentUser = springSecurityService.currentUser as Person
        return request.isUserInRole('ROLE_ADMIN') || currentUser.id == p?.id
    }

    @Secured(['IS_AUTHENTICATED_ANONYMOUSLY'])
    def create() {
        if (!springSecurityService.isLoggedIn() || request.isUserInRole('ROLE_ADMIN')) {
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

        SecRole userRole = SecRole.findByAuthority('ROLE_USER')
        if (!activation.person.authorities.contains(userRole)) {
            SecUserSecRole.create(activation.person, userRole, true)
        }

        String link = grailsLinkGenerator.link(controller: 'person', action: 'activate', params: [activateCode: code], absolute: true)
        mailService.sendMail {
            async true
            to personInstance.username
            subject "Instabase Account Activation"
            html g.render(template: "/mail/activate", model: [link:link])
        }

        def authentication = new UsernamePasswordAuthenticationToken(
                personInstance.username,
                params.password
        )
        SecurityContextHolder.context.authentication = authenticationManager.authenticate(authentication)

        flash.message = 'REG_SUCCESS'
        redirect (controller: 'node', action: 'index')
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
                if (!activation.person.authorities.contains(SecRole.findByAuthority('ROLE_USER'))) {
                    SecUserSecRole.create(activation.person, SecRole.findByAuthority('ROLE_USER'))
                }
                render(view: 'success', model: ['text': "Activation success!"])
            } else {
                render(view: 'error', model: ['text': "Wrong activation code"])
            }
        }
    }

    @Secured(['ROLE_USER'])
    def edit(Person personInstance) {
        if (hasAccessToPerson(personInstance)) {
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

        if (!hasAccessToPerson(personInstance)) {
            render(status: FORBIDDEN, view: 'error', model: [text: 'You can not update other accounts.'])
        } else {
            if (personInstance.hasErrors()) {
                respond personInstance.errors, view: 'edit'
                return
            }

            personInstance.save flush: true

            request.withFormat {
                form multipartForm {
                    flash.message = message(code: 'default.updated.message', args: [message(code: 'person.label', default: 'Person'), personInstance.id])
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

        if (springSecurityService.currentUser == personInstance) {
            flash.message = message(code: 'default.not.deleted.message', args: [message(code: 'person.label', default: 'Person'), personInstance.id])
            redirect action: "list", method: "GET"
            return
        }

        Activation.where { person == personInstance }.deleteAll()
        SecUserSecRole.removeAll(personInstance)
        personInstance.delete flush: true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'person.label', default: 'Person'), personInstance.id])
                redirect action: "list", method: "GET"
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
