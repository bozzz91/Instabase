<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'person.label', default: 'Person')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
        <script src="<g:createLinkTo dir='js' file='jstree.min.js'/>"></script>
        <link rel="stylesheet" type="text/css" href="<g:createLinkTo dir='css' file='themes/default/style.min.css'/>" />
        <g:render template="tree"/>
        <sec:ifLoggedIn>
            <g:render template="../node/upgrade"/>
        </sec:ifLoggedIn>
	</head>
	<body>
		<div class="nav" role="navigation">
			<ul>
                <li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
                <li><a class="list" href="${createLink(controller: 'node')}"><g:message code="node.bases.label"/></a></li>
			</ul>
		</div>
        <br/>
        <g:render template="/layouts/tabs" model="[free: free]"/>

        <div class="categoty-title">
            <g:if test="${free}">
                Бесплатные базы ${params.category}<br/>
                <div class="categoty-title-warning">Внимание! Размер бесплатных баз во много раз меньше, чем у платных.</div>
            </g:if>
            <g:else>
                Мои базы ${params.category}
            </g:else>
        </div>
		<div class="divider1"></div>
        <div id="cat-empty-div" style="display: none" class="categoty-empty">
            <g:if test="${free}">
                К сожалению, данная категория пока пуста
            </g:if>
            <g:else>
                Нет купленных баз в данной категории
            </g:else>
        </div>
        <div id="introspection_tree"></div>

        <div id="dialog" title="<g:message code='dialog.info.title'/>" style="display: none"></div>
	</body>
</html>
