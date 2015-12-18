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
		<meta name="viewport" content="width=device-width, maximum-scale=2.0, minimum-scale=1, initial-scale=1 user-scalable=yes">
		<link rel="shortcut icon" href="${assetPath(src: 'favicon1.ico')}" type="image/x-icon">
		<link rel="apple-touch-icon" sizes="57x57" href="${assetPath(src: 'apple-icon-57x57.png')}">
		<link rel="apple-touch-icon" sizes="60x60" href="${assetPath(src: 'apple-icon-60x60.png')}">
		<link rel="apple-touch-icon" sizes="72x72" href="${assetPath(src: 'apple-icon-72x72.png')}">
		<link rel="apple-touch-icon" sizes="76x76" href="${assetPath(src: 'apple-icon-76x76.png')}">
		<link rel="apple-touch-icon" sizes="114x114" href="${assetPath(src: 'apple-icon-114x114.png')}">
		<link rel="apple-touch-icon" sizes="120x120" href="${assetPath(src: 'apple-icon-120x120.png')}">
		<link rel="apple-touch-icon" sizes="144x144" href="${assetPath(src: 'apple-icon-144x144.png')}">
		<link rel="apple-touch-icon" sizes="152x152" href="${assetPath(src: 'apple-icon-152x152.png')}">
		<link rel="apple-touch-icon" sizes="180x180" href="${assetPath(src: 'apple-icon-180x180.png')}">
		<link rel="icon" type="image/png" sizes="192x192"  href="${assetPath(src: 'android-icon-192x192.png')}">
		<link rel="icon" type="image/png" sizes="32x32" href="${assetPath(src: 'favicon-32x32.png')}">
		<link rel="icon" type="image/png" sizes="96x96" href="${assetPath(src: 'favicon-96x96.png')}">
		<link rel="icon" type="image/png" sizes="16x16" href="${assetPath(src: 'favicon-16x16.png')}">
		<link rel="manifest" href="${assetPath(src: 'manifest.json')}">
		<meta name="msapplication-TileColor" content="#ffffff">
		<meta name="msapplication-TileImage" content="${assetPath(src: 'ms-icon-144x144.png')}">
  		<asset:stylesheet src="application.css"/>
		<asset:javascript src="application.js"/>
        <asset:stylesheet src="instabase.css"/>
        <jqui:resources/>
		<g:layoutHead/>
	</head>
	<body>
		<div id="grailsLogo" role="banner">
			<a href="${createLink(url:'/')}"><img src="${createLinkTo(dir: "images", file: "logo.png")}"/></a>
			<a href="/" title="Заказать продвижение в Instagram" alt="Заказать продвижение в Instagram" target="_blank"><div class="btn-order-top">Заказать продвижение аккаунта Instargam</div></a>
		</div>
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
                        <ul type="none">
                            <li>
                                <g:link controller="login" action="auth"><div class="btn-action">Войти</div></g:link>
                            </li>
                            <li>
                                <g:link controller="person" action="create"><div class="btn-action">Регистрация</div></g:link>
                            </li>
                        </ul>
                    </sec:ifNotLoggedIn>
                </span>
            </div>
            <div class="navigation-info with-shadow-box">
                <ul type="none">
                    <li><a href="${createLink(controller:'node', action: 'index')}"><div class="btn-action">Список баз</div></a></li>
                    <sec:ifAllGranted roles="ROLE_USER">
                        <li><a href="${createLink(controller:'person', action: 'index')}"><div class="btn-action">Мои базы</div></a></li>
                        <li><a href="${createLink(controller:'payment', action: 'index')}"><div class="btn-action">Мои платежи</div></a></li>
                    </sec:ifAllGranted>
                    <sec:ifAllGranted roles="ROLE_ADMIN">
                        <li>
                            <br/>Admin menu<br/>
                            <a href="${createLink(controller:'payment', action: 'list')}"><div class="btn-action">Все платежи</div></a>
                            <a href="${createLink(controller:'base', action: 'init')}"><div class="btn-action">Инициализация</div></a>
                            <a href="${createLink(uri: '/monitoring')}"><div class="btn-action">Мониторинг</div></a>
                        </li>
                    </sec:ifAllGranted>
                </ul>
            </div>
        </div>
        <div class="workspace with-shadow-box">
		    <g:layoutBody/>
        </div>
		<div class="footer" role="contentinfo">
			<p>InstaBase.su &#169; 2015. Все права защищены.</p>
			<p><a href="#">ПОЛИТИКА КОНФИДЕНЦИАЛЬНОСТИ</a></p>
		</div>
		<div id="spinner" class="spinner" style="display:none;">
            <g:message code="spinner.alt" default="Loading&hellip;"/>
        </div>
	</body>
</html>
