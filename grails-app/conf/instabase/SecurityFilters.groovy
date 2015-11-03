package instabase

class SecurityFilters {

    def filters = {
        all(controller:'*', action:'*') {
            before = {
                /*if (!controllerName) {
                    return true
                }
                def allowedActions = ['auth', 'show', 'index', 'login', 'validate', 'generateFileList']
                def adminActions = ['create', 'delete', 'update']
                if (session.user) {
                    if (adminActions.contains(actionName)) {
                        return session.user.role?.name == 'admin'
                    }
                    return true
                } else {
                    if (!allowedActions.contains(actionName)) {
                        redirect(controller: 'person', action: 'login',
                                params: ['cName': controllerName, 'aName': actionName])
                        return false
                    }
                }*/
            }
            after = { Map model ->

            }
            afterView = { Exception e ->

            }
        }
    }
}
