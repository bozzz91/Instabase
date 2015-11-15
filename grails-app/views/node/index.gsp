<%@ page import="instabase.Node" %>

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
                <li><a class="list" href="${createLink(controller: 'node')}"><g:message code="node.bases.label"/></a></li>
                <sec:ifLoggedIn>
                    <li><a class="create" href="#" onclick="submitPurchase()"><g:message code="purchase.label"/></a></li>
                </sec:ifLoggedIn>
			</ul>
		</div>
        <br/>
        <div class="nav category-nav" role="navigation">
            <ul>
                <li class="category-tab">
                    <a class="a-category-tab tab-insta" href="${createLink(action: 'index', params: ['category':'Instagram'])}">Instagram</a>
                </li>
                <li class="category-tab">
                    <a class="a-category-tab tab-vk"href="${createLink(action: 'index', params: ['category':'VK'])}">VK</a>
                </li>
                <li class="category-tab">
                    <a class="a-category-tab tab-unknown"href="${createLink(action: 'index', params: ['category':'Unknown'])}">Unknown</a>
                </li>
            </ul>
        </div>

        <div id="introspection_tree"></div>

        <div id="dialog" title="Information" style="display: none"></div>
	</body>
</html>
