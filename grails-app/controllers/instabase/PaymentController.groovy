package instabase

import grails.plugin.springsecurity.annotation.Secured

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional

@Secured(['ROLE_USER'])
@Transactional(readOnly = true)
class PaymentController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE", notification: "POST"]

    def springSecurityService
    def paymentService

    @Transactional
    @Secured(['permitAll'])
    def notification() {
        log.error("new notification: ${params}")
        def sha1 = params.sha1_hash
        def secret = paymentService.getSecret()
        String mySha1 = params.notification_type + '&' +
                params.operation_id + '&' +
                params.amount + '&' +
                params.currency + '&' +
                params.datetime + '&' +
                params.sender + '&' +
                params.codepro + '&' +
                secret + '&' +
                params.label;
        mySha1 = mySha1.encodeAsSHA1();
        if (sha1 == mySha1) {
            Payment pay = Payment.findById(params.label ? (params.label as Long) : 0l)
            if (pay) {
                if (params.withdraw_amount) {
                    pay.amount = params.withdraw_amount as Double
                } else {
                    pay.amount = params.amount as Double
                }
                pay.payDate = Date.parse("yyyy-MM-dd'T'HH:mm:ss'Z'", params.datetime as String)
                pay.operationId = params.operation_id
                Boolean unaccepted = params.unaccepted ? Boolean.valueOf("${params.unaccepted}") : false
                Boolean codePro = params.codepro ? Boolean.valueOf("${params.codepro}") : false
                if (unaccepted || codePro) {
                    pay.state = Payment.State.PROCESS
                } else {
                    pay.state = Payment.State.DONE
                }
                pay.save()
                pay.owner.cash += pay.amount
                pay.owner.save()
            }
        } else {
            log.error(sha1 + "!=" + mySha1)
        }
        render status: OK, text: "OK"
    }

    private boolean hasAccessToPayment(Payment payment) {
        Person user = springSecurityService.currentUser as Person
        return request.isUserInRole('ROLE_ADMIN') || user.id == payment.owner.id
    }

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        List<Payment> payments = Payment.findAll(
                "from Payment as p where p.owner=? order by p.creationDate desc",
                [springSecurityService.currentUser as Person]
        )
        respond payments, model: [paymentInstanceCount: payments.size()]
    }

    @Secured(['ROLE_ADMIN'])
    def list(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond Payment.list(params), model: [paymentInstanceCount: Payment.count()]
    }

    def show(Payment paymentInstance) {
        if (hasAccessToPayment(paymentInstance)) {
            respond paymentInstance, [user: springSecurityService.currentUser as Person]
        } else {
            render(status: FORBIDDEN, view: 'error', model: [text: 'Access denied.'])
        }
    }

    def create() {
        Payment payment = new Payment(params)
        payment.owner = springSecurityService.currentUser as Person
        params.owner = payment.owner
        respond payment
    }

    @Transactional
    def save(Payment paymentInstance) {
        if (paymentInstance == null) {
            notFound()
            return
        }

        paymentInstance.owner = springSecurityService.currentUser as Person
        if (paymentInstance.hasErrors()) {
            respond paymentInstance.errors, view: 'create'
            return
        }

        paymentInstance.save flush: true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'payment.label', default: 'Payment'), paymentInstance.id])
                redirect paymentInstance
            }
            '*' { respond paymentInstance, [status: CREATED] }
        }
    }

    @Secured(['ROLE_ADMIN'])
    def edit(Payment paymentInstance) {
        respond paymentInstance
    }

    @Transactional
    @Secured(['ROLE_ADMIN'])
    def update(Payment paymentInstance) {
        if (paymentInstance == null) {
            notFound()
            return
        }

        if (paymentInstance.hasErrors()) {
            respond paymentInstance.errors, view: 'edit'
            return
        }

        paymentInstance.save flush: true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'Payment.label', default: 'Payment'), paymentInstance.id])
                redirect paymentInstance
            }
            '*' { respond paymentInstance, [status: OK] }
        }
    }

    @Transactional
    def delete(Payment paymentInstance) {

        if (paymentInstance == null) {
            notFound()
            return
        }

        paymentInstance.delete flush: true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'Payment.label', default: 'Payment'), paymentInstance.id])
                redirect action: "index", method: "GET"
            }
            '*' { render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'payment.label', default: 'Payment'), params.id])
                redirect action: "index", method: "GET"
            }
            '*' { render status: NOT_FOUND }
        }
    }
}
