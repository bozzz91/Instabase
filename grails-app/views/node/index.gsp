<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'node.label', default: 'Node')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
        <script src="<g:createLinkTo dir='js' file='jstree.min.js'/>"></script>
        <link rel="stylesheet" type="text/css" href="<g:createLinkTo dir='css' file='themes/default/style.min.css'/>" />
        <g:render template="tree"/>
        <sec:ifLoggedIn>
            <g:render template="purchase"/>
        </sec:ifLoggedIn>
	</head>
	<body>
        <div class="nav" role="navigation">
            <ul>
                <li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
                <sec:ifLoggedIn>
                    <li><a class="create" href="#" onclick="submitPurchase()"><g:message code="purchase.label"/></a></li>
                </sec:ifLoggedIn>
            </ul>
        </div>
        <br/>
		<h3>Категории баз</h3>
        <g:render template="/layouts/tabs"/>

        <div class="categoty-title">${params.category}</div>
		<div class="divider1"></div>
        <div id="introspection_tree"></div>

        <div id="dialog" title="Подтверждение" style="display: none"></div>
	</body>
</html>
