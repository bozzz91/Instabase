package instabase

import grails.plugin.springsecurity.annotation.Secured
import org.springframework.web.multipart.MultipartFile
import org.springframework.web.multipart.MultipartHttpServletRequest
import org.springframework.web.multipart.commons.CommonsMultipartFile

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional

@Secured(['ROLE_ADMIN'])
@Transactional(readOnly = true)
class BaseController {

    def springSecurityService
    def contentService

    static allowedMethods = [save: "POST", update: "POST", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond Base.list(params), model: [baseInstanceCount: Base.count()]
    }

    def show(Base baseInstance) {
        respond baseInstance
    }

    @Secured(['ROLE_USER'])
    def download(Base baseInstance) {
        Person person = springSecurityService.currentUser as Person
        if (person.bases.contains(baseInstance)) {
            File baseFile = contentService.getBaseFile(baseInstance)
            if (baseFile.exists()) {
                response.setCharacterEncoding("UTF-8")
                response.setContentType("application/octet-stream")
                response.setHeader("Content-disposition", "attachment;filename=${URLEncoder.encode(baseInstance.contentName, "UTF-8")}")
                response.outputStream << new FileInputStream(baseFile)
                response.outputStream.flush()
            } else {
                render(status: INTERNAL_SERVER_ERROR, view: 'error', model: [text: "Base doesn't exists"])
            }
        } else {
            render(status: FORBIDDEN, view: 'error', model: [text: 'You can not download base because you did not purchase it yet.'])
        }

    }

    def create() {
        params.type = 'База'
        respond new Base(params)
    }

    CommonsMultipartFile processUpload(Base inst) {
        def req = request as MultipartHttpServletRequest
        def upload = req.getFile('filePath') as CommonsMultipartFile
        if (!upload.isEmpty()) {
            log.info "not empty file"
            inst.contentName = upload.originalFilename
            inst.length = upload.size
            params.filePath = inst.filePath
        } else {
            log.info "empty file"
            inst.filePath = null
        }
        inst.clearErrors()
        return upload
    }

    def saveUpload(Base base, def upload) {
        upload = upload as CommonsMultipartFile
        if (!upload.isEmpty()) {
            contentService.saveBaseFile(base, upload)
        }
        base.validate()
    }

    @Transactional
    def save(Base baseInstance) {
        if (baseInstance == null) {
            notFound()
            return
        }

        def upload = processUpload(baseInstance)
        if (baseInstance.hasErrors()) {
            respond baseInstance.errors, view: 'create'
            return
        }

        saveUpload(baseInstance, upload)
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

        def upload = processUpload(baseInstance)
        if (baseInstance.hasErrors()) {
            respond baseInstance.errors, view: 'edit'
            return
        }

        saveUpload(baseInstance, upload)
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
