<%@ page import="instabase.Person" %>
<!DOCTYPE html>
<!--[if lt IE 7 ]> <html lang="en" class="no-js ie6"> <![endif]-->
<!--[if IE 7 ]>    <html lang="en" class="no-js ie7"> <![endif]-->
<!--[if IE 8 ]>    <html lang="en" class="no-js ie8"> <![endif]-->
<!--[if IE 9 ]>    <html lang="en" class="no-js ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang="en" class="no-js"><!--<![endif]-->
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<title><g:layoutTitle default="Grails"/></title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link rel="shortcut icon" href="${assetPath(src: 'favicon.ico')}" type="image/x-icon">
		<link rel="apple-touch-icon" href="${assetPath(src: 'apple-touch-icon.png')}">
		<link rel="apple-touch-icon" sizes="114x114" href="${assetPath(src: 'apple-touch-icon-retina.png')}">
  		<asset:stylesheet src="application.css"/>
		<asset:javascript src="application.js"/>
        <asset:stylesheet src="instabase.css"/>
        <jqui:resources/>
		<g:layoutHead/>
	</head>
	<body>
		<div id="grailsLogo" role="banner"><a href="${createLink(url:'/')}"><img src="${createLinkTo(dir: "images", file: "logo.png")}"/></a></div>
        <div class="left-panel">
            <div class="person-info with-shadow-box">
                <span id='loginLink' style='position: relative;'>
                    <sec:ifLoggedIn>
                        <g:render template="/person/personShortInfo" model="[user: Person.findById(sec.loggedInUserInfo(field: 'id') as Long)]"/>
                        <g:form controller="logout" action="index" method="POST">
                            <fieldset class="buttons">
                                <g:actionSubmit class="logout" action="index"
                                                value="${message(code: 'default.button.logout.label', default: 'Logout')}"/>
                            </fieldset>
                        </g:form>
                    </sec:ifLoggedIn>
                    <sec:ifNotLoggedIn>
                        <ul>
                            <li>
                                <g:link controller="login" action="auth">Login</g:link>
                            </li>
                            <li>
                                <g:link controller="person" action="create">Register</g:link>
                            </li>
                        </ul>
                    </sec:ifNotLoggedIn>
                </span>
            </div>
            <div class="navigation-info with-shadow-box">
                <ul>
                    <li><a href="${createLink(controller:'node', action: 'index')}">Список баз</a></li>
                    <li><a href="${createLink(controller:'person', action: 'index')}">Мои базы</a></li>
                    <li><a href="${createLink(controller:'payment', action: 'index')}">Мои платежи</a></li>
                    <sec:ifAllGranted roles="ROLE_ADMIN">
                        <li>
                            <br/>Admin menu<br/>
                            <a href="${createLink(controller:'payment', action: 'list')}">Все платежи</a>
                            <a href="${createLink(controller:'base', action: 'init')}">Инициализация</a>
                        </li>
                    </sec:ifAllGranted>
                </ul>
            </div>
        </div>
        <div class="workspace with-shadow-box">
		    <g:layoutBody/>
        </div>
		<div class="footer" role="contentinfo"></div>
		<div id="spinner" class="spinner" style="display:none;">
            <g:message code="spinner.alt" default="Loading&hellip;"/>
        </div>
	</body>
</html>
