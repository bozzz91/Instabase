package instabase

import grails.plugin.springsecurity.annotation.Secured
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

    def index(Integer max, String sort, String order) {
        params.max = Math.min(max ?: 10, 100)
        params.sort = sort ?: 'updateDate'
        params.order = order ?: 'desc'
        respond Base.list(params), model: [baseInstanceCount: Base.count()]
    }

    @Secured(['ROLE_USER'])
    def show(Base baseInstance) {
        if (hasAccessToBase(baseInstance)) {
            respond baseInstance
        } else {
            render(status: FORBIDDEN, view: 'error', model: [text: 'You can not open base because you did not purchase it yet.'])
        }
    }

    @Secured(['IS_AUTHENTICATED_ANONYMOUSLY'])
    def download(Base baseInstance, boolean free) {
        if (hasAccessToBase(baseInstance)) {
            Person user = springSecurityService.currentUser as Person
            Map fileData = contentService.getBaseFile(baseInstance, user, free)
            File baseFile = fileData.file
            String ext = fileData.ext
            if (baseFile.exists()) {
                response.setCharacterEncoding("UTF-8")
                response.setContentType("application/octet-stream")
                response.setHeader("Content-disposition", "attachment;filename=${URLEncoder.encode(baseInstance.name +'.'+ ext, "UTF-8")}")
                def stream = new FileInputStream(baseFile)
                response.outputStream << stream
                response.outputStream.flush()
                stream.close()
            } else {
                log.error('path not exists: ' + baseFile.absolutePath)
                render(status: INTERNAL_SERVER_ERROR, view: 'error', model: [text: "Base doesn't exists"])
            }
        } else {
            render(status: FORBIDDEN, view: 'error', model: [text: 'You can not download base because you did not purchase it yet.'])
        }
    }

    private boolean hasAccessToBase(Base b) {
        Person user = springSecurityService.currentUser as Person
        return request.isUserInRole('ROLE_ADMIN') || b.cost < 0.000001d || b.free || (b?.id && user?.id && PersonBase.exists(user.id, b.id))
    }

    @Transactional
    def init() {
        contentService.initFromStorage()
        flash.message = 'Инициализация прошла успешно'
        redirect action: 'index'
    }

    @Transactional
    def initCost() {
        contentService.recalculateNodes()
        flash.message = 'Обновление цен и количества баз в категориях прошло успешно'
        redirect action: 'index'
    }

    @Transactional
    def migrateStorage() {
        //contentService.migrateStorage()
        flash.message = 'Миграция хранилища прошла успешно'
        redirect action: 'index'
    }

    def create() {
        respond new Base(params)
    }

    private CommonsMultipartFile processUpload(Base inst) {
        def req = request as MultipartHttpServletRequest
        def upload = req.getFile('filePath') as CommonsMultipartFile
        if (!upload.isEmpty()) {
            inst.contentName = contentService.generateNameAndExt(upload.originalFilename).ext
            inst.length = upload.size
            params.filePath = inst.filePath
        } else {
            if (inst.filePath instanceof String) {
                params.filePath = inst.filePath
            } else {
                params.filePath = null
            }
        }
        inst.clearErrors()
        return upload
    }

    private def saveUpload(Base base, def upload) {
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
        contentService.updateBaseParents(baseInstance, baseInstance.cost, true)

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

        Double oldCost = Base.load(baseInstance.id).cost
        saveUpload(baseInstance, upload)
        baseInstance.save flush: true
        contentService.updateBaseParents(baseInstance, baseInstance.cost - oldCost)

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

        PersonBase.removeAll(baseInstance, true)
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
