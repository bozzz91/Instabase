<%@ page import="instabase.Node" %>

<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'person.label', default: 'Person')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<div class="nav" role="navigation">
			<ul>
                <li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
                <li><a class="list" href="${createLink(controller: 'node')}"><g:message code="node.bases.label"/></a></li>
			</ul>
		</div>

        <ul class="success">
            <li>${text}</li>
        </ul>
	</body>
</html>
