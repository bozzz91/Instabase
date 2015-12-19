package instabase

import grails.plugin.springsecurity.annotation.Secured
import grails.util.Metadata

@Secured(['permitAll'])
class FeedbackFormController {

    static allowedMethods = [index: "POST", orderBase: "POST", orderPromotion: "POST"]

    def mailService

    /**
     * обратная связь
     */
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
            render (view: 'index', model: [success: true, title: 'Обратная связь'])
        } catch (Exception ignored) {
            render (view: 'index', model: [success: false, title: 'Обратная связь'])
        }
    }

    /**
     * заказать базу
     */
    def orderBase() {
        try {
            String msg = "Заказ базы\n";
            msg += "E-mail: ${params.email}\n";
            msg += "Город: ${params.city}\n";
            msg += "Тип базы: ${params.type_order}\n";
            msg += "Фильтр: ${params.filter}\n";
            msg += "Нужна база к дате: ${params.date}\n";
            mailService.sendMail {
                to Metadata.getCurrent().getProperty("instabase.admin.email")
                subject "Персональный заказ базы"
                body msg
            }
            render (view: 'index', model: [success: true, title: 'Заказ базы'])
        } catch (Exception ignored) {
            render (view: 'index', model: [success: false, title: 'Заказ базы'])
        }
    }

    /**
     * заказать продвижение
     */
    def orderPromotion() {
        try {
            String msg = "Заказ продвижения аккаунта\n";
            msg += "E-mail: ${params.email}\n";
            msg += "Аккаунты: ${params.account}\n";
            msg += "Желаемый результат: ${params.wresult}\n";
            msg += "Доп. информация: ${params.addinfo}\n";
            mailService.sendMail {
                to Metadata.getCurrent().getProperty("instabase.admin.email")
                subject "Заказ продвижения аккаунта"
                body msg
            }
            render (view: 'index', model: [success: true, title: 'Заказ продвижения'])
        } catch (Exception ignored) {
            render (view: 'index', model: [success: false, title: 'Заказ продвижения'])
        }
    }
}
