class UrlMappings {

	static mappings = {
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }

        "/"(view:"/index")
        "/feedback"(view:"/feedback")
        "/confidential"(view:"/confidential")
        "/about"(view:"/about")
        "/blog"(view:"/blog")
        "500"(view:'/error')
        "403"(view:'/error')
	}
}
