
<%@ page import="instabase.Base" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'base.label', default: 'Base')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#list-base" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="list-base" class="content scaffold-list" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
			<thead>
					<tr>
					
						<g:sortableColumn property="name" title="${message(code: 'base.name.label', default: 'Name')}" />
					
						<g:sortableColumn property="type" title="${message(code: 'base.type.label', default: 'Type')}" />
					
						<th><g:message code="base.parent.label" default="Parent" /></th>
					
						<g:sortableColumn property="creationDate" title="${message(code: 'base.creationDate.label', default: 'Creation Date')}" />
					
						<g:sortableColumn property="cost" title="${message(code: 'base.cost.label', default: 'Cost')}" />
					
						<g:sortableColumn property="contentName" title="${message(code: 'base.contentName.label', default: 'Content Name')}" />
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${baseInstanceList}" status="i" var="baseInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td><g:link action="show" id="${baseInstance.id}">${fieldValue(bean: baseInstance, field: "name")}</g:link></td>
					
						<td>${fieldValue(bean: baseInstance, field: "type")}</td>
					
						<td>${fieldValue(bean: baseInstance, field: "parent")}</td>
					
						<td><g:formatDate date="${baseInstance.creationDate}" /></td>
					
						<td>${fieldValue(bean: baseInstance, field: "cost")}</td>

						<td>${fieldValue(bean: baseInstance, field: "contentName")}</td>
					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${baseInstanceCount ?: 0}" />
			</div>
		</div>
	</body>
</html>
