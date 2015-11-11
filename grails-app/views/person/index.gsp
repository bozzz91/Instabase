<%@ page import="instabase.Node" %>

<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'person.label', default: 'Person')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
        <script src="<g:createLinkTo dir='js' file='jstree.min.js'/>"></script>
        <link rel="stylesheet" type="text/css" href="<g:createLinkTo dir='css' file='themes/default/style.min.css'/>" />
        <g:render template="tree"/>
	</head>
	<body>
		<div class="nav" role="navigation">
			<ul>
                <li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
                <li><a class="list" href="${createLink(controller: 'node')}"><g:message code="node.bases.label"/></a></li>
			</ul>
		</div>

        <div id="introspection_tree"></div>

        <div id="dialog" title="<g:message code='dialog.info.title'/>" style="display: none"></div>
	</body>
</html>
