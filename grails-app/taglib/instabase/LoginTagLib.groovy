package instabase

class LoginTagLib {
    static defaultEncodeAs = [taglib:'text']
    //static encodeAsForTags = [tagName: [taglib:'html'], otherTagName: [taglib:'none']]

    def loginToggle = {
        out << "<div style='text-align: center;margin: 15px 0 40px;'>"
        if (request.getSession(false) && session.user) {
            out << "<span style='margin-left: 15px'>"
            out << "Welcome ${session.user}."
            out << "</span><span style='float:right;margin-right:15px'>"
            out << "<a href='${createLink(controller:'person', action:'logout')}'>"
            out << "Logout </a></span>"
        } else{
            out << "<span style='margin-right:10px'>"
            out << "<a href='${createLink(controller:'person', action:'login')}'>"
            out << "Login </a></span>"
        }
        out << "</div><br/>"
    }
}
