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
        log.error("new payment notification: ${params}")
        String crc = params.SignatureValue
        def invId = params.InvId
        def outSum = params.OutSum
        def test = params.IsTest
        Properties secret = paymentService.getSecret()
        String myCrc = "${outSum}:${invId}:${secret.pass2}".encodeAsMD5()
        if (crc.toUpperCase() == myCrc.toUpperCase()) {
            if (test == "1") {
                render status: OK, text: "OK${invId}"
            } else {
                Payment pay = Payment.findById(invId ? (invId as Long) : 0l)
                if (pay) {
                    if (outSum) {
                        pay.amount = outSum as Double
                    }
                    pay.payDate = new Date()
                    pay.state = Payment.State.DONE
                    pay.save()
                    pay.owner.cash += pay.amount
                    pay.owner.save()
                    render status: OK, text: "OK${invId}"
                } else {
                    render status: INTERNAL_SERVER_ERROR, text: "Платеж не найден"
                }
            }
        } else {
            log.error(crc + " != " + myCrc)
            render status: INTERNAL_SERVER_ERROR, text: "CRC not equals"
        }
    }

    private boolean hasAccessToPayment(Payment payment) {
        Person user = springSecurityService.currentUser as Person
        return request.isUserInRole('ROLE_ADMIN') || (user.id == payment?.owner?.id && payment?.state != Payment.State.DELETE)
    }

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        List<Payment> payments = Payment.findAll(
                "from Payment as p where p.owner=? and p.state<>? order by p.creationDate desc",
                [springSecurityService.currentUser as Person, Payment.State.DELETE]
        )
        respond payments, model: [paymentInstanceCount: payments.size()]
    }

    @Secured(['ROLE_ADMIN'])
    def list(Integer max, String sort, String order) {
        params.max = Math.min(max ?: 10, 100)
        params.sort = sort ?: 'creationDate'
        params.order = order ?: 'desc'
        respond Payment.list(params), model: [paymentInstanceCount: Payment.count()]
    }

    def show(Payment paymentInstance) {
        if (hasAccessToPayment(paymentInstance)) {
            Properties secret = paymentService.getSecret()
            String crc = "InstaBase:${paymentInstance.amount}:${paymentInstance.id}:${secret.pass1}".encodeAsMD5().toUpperCase()
            respond (paymentInstance, [user: springSecurityService.currentUser, model: [crc: crc, test: secret.test]])
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
        paymentInstance.clearErrors()
        paymentInstance.validate()
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
