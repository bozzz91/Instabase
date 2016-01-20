<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<title><g:message code="node.bases.label"/></title>
        <script src="<g:createLinkTo dir='js' file='jstree.min.js'/>"></script>
        <link rel="stylesheet" type="text/css" href="<g:createLinkTo dir='css' file='themes/default/style.min.css'/>" />
        <g:render template="tree"/>
        <sec:ifLoggedIn>
            <g:render template="purchase"/>
            <g:render template="upgrade"/>
        </sec:ifLoggedIn>
        <sec:ifNotLoggedIn>
            <g:render template="needLoginToPurchase"/>
        </sec:ifNotLoggedIn>
	</head>
	<body>
        <g:render template="nav"/>
        <br/>
		<h3>Категории баз</h3>
        <g:render template="/layouts/tabs"/>

        <div class="category-title">${category}</div>
		<div class="divider1"></div>
        <div id="cat-empty-div" style="display: none" class="category-empty">
            К сожалению, данная категория пока пуста
        </div>
        <div id="introspection_tree"></div>

        <div id="dialog" title="Подтверждение" style="display: none"></div>
	</body>
</html>
