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
                <span id='loginLink' style='position: relative; margin-right: 30px; float: right'>
                    <sec:ifLoggedIn>
                        Logged in as <sec:username/>
                        <form name="logout" method="POST" action="${createLink(controller:'logout')}">
                            <input type="submit" value=" (logout)">
                        </form>
                    </sec:ifLoggedIn>
                    <sec:ifNotLoggedIn>
                        <form name="login" method="GET" action="${createLink(controller:'login')}">
                            <input type="submit" value="Login">
                        </form>
                    </sec:ifNotLoggedIn>
                </span>
            </div>
            <div class="navigation-info with-shadow-box">
                <a href="#">Link menu 1</a>
                <a href="#">Link menu 2</a>
            </div>
        </div>
        <div class="workspace with-shadow-box">
		    <g:layoutBody/>
        </div>
		<div class="footer" role="contentinfo"></div>
		<div id="spinner" class="spinner" style="display:none;"><g:message code="spinner.alt" default="Loading&hellip;"/></div>
	</body>
</html>
