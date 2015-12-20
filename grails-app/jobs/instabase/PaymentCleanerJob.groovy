package instabase

import grails.transaction.Transactional

@Transactional
class PaymentCleanerJob {
    static triggers = {
        simple repeatInterval: 30*60*1000l // execute job once in 30 minutes
    }

    def execute() {
        Calendar cal = Calendar.getInstance()
        cal.add(Calendar.DAY_OF_MONTH, -1)
        Payment.findAllByCreationDateLessThanAndState(cal.getTime(), Payment.State.WAIT).each { payment ->
            payment.state = Payment.State.DELETE
            payment.save()
        }

        cal.add(Calendar.DAY_OF_MONTH, -10)
        Payment.findAllByCreationDateLessThanAndState(cal.getTime(), Payment.State.DELETE).each { payment ->
            payment.delete()
        }
    }
}
