package instabase

class SecurityFilters {

    def springSecurityService

    def filters = {
        all(controller:'*', action:'*') {
            before = {

            }
            after = { Map model ->
                if (model && springSecurityService.isLoggedIn()) {
                    model['user'] = Person.get(springSecurityService.principal.id as Long)
                }
            }
            afterView = { Exception e ->

            }
        }
    }
}
