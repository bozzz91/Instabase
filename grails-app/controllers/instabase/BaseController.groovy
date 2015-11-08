package instabase


import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional

@Transactional(readOnly = true)
class BaseController {

    static allowedMethods = [save: "POST", update: "POST", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond Base.list(params), model: [baseInstanceCount: Base.count()]
    }

    def show(Base baseInstance) {
        respond baseInstance
    }

    def download(Base baseInstance) {
        response.setContentType("application/octet-stream")
        response.setHeader("Content-disposition", "attachment;filename=\"${baseInstance.contentName}\"")
        response.outputStream << baseInstance.content
        response.outputStream.flush()
    }

    def create() {
        params.type = 'База'
        respond new Base(params)
    }

    @Transactional
    def save(Base baseInstance) {
        if (baseInstance == null) {
            notFound()
            return
        }

        if (baseInstance.hasErrors()) {
            respond baseInstance.errors, view: 'create'
            return
        }

        baseInstance.save flush: true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'base.label', default: 'Base'), baseInstance.id])
                redirect baseInstance
            }
            '*' { respond baseInstance, [status: CREATED] }
        }
    }

    def edit(Base baseInstance) {
        respond baseInstance
    }

    @Transactional
    def update(Base baseInstance) {
        if (baseInstance == null) {
            notFound()
            return
        }

        if (baseInstance.hasErrors()) {
            respond baseInstance.errors, view: 'edit'
            return
        }

        def fileName = params.content?.fileItem?.fileName
        baseInstance.contentName = fileName
        baseInstance.save flush: true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'Base.label', default: 'Base'), baseInstance.id])
                redirect baseInstance
            }
            '*' { respond baseInstance, [status: OK] }
        }
    }

    @Transactional
    def delete(Base baseInstance) {

        if (baseInstance == null) {
            notFound()
            return
        }

        baseInstance.delete flush: true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'Base.label', default: 'Base'), baseInstance.id])
                redirect action: "index", method: "GET"
            }
            '*' { render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'base.label', default: 'Base'), params.id])
                redirect action: "index", method: "GET"
            }
            '*' { render status: NOT_FOUND }
        }
    }
}
