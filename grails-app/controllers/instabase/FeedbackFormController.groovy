package instabase

import grails.plugin.springsecurity.annotation.Secured
import grails.transaction.Transactional
import grails.util.Metadata

@Secured(['permitAll'])
@Transactional(readOnly = true)
class FeedbackFormController {

    def mailService

    def index() {
        try {
            String msg = "Обратная связь с сайта\n";
            msg += "Имя: ${params.name}\n";
            msg += "E-mail: ${params.email}\n";
            msg += "Тип сообщения: ${params.type_mes}\n";
            msg += "Текст сообщения: ${params.message}\n";
            mailService.sendMail {
                to Metadata.getCurrent().getProperty("instabase.admin.email")
                subject "User's Feedback"
                body msg
            }
            render (view: 'index', model: [success: true])
        } catch (Exception ignored) {
            render (view: 'index', model: [success: false])
        }
    }
}
