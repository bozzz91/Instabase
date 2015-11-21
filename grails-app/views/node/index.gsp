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
		<g:render template="nav"/>
        <br/>
        <g:render template="/layouts/tabs"/>

        <div>${params.category}</div>
        <div id="introspection_tree"></div>

        <div id="dialog" title="Information" style="display: none"></div>
	</body>
</html>
