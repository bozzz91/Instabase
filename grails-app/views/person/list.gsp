
<%@ page import="instabase.Person" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'person.label', default: 'Person')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#list-person" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
			</ul>
		</div>
		<div id="list-person" class="content scaffold-list" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
			<thead>
					<tr>

                        <g:sortableColumn property="username" title="${message(code: 'person.username.label', default: 'Username')}" />
					
						<g:sortableColumn property="created" title="${message(code: 'person.created.label', default: 'Creation Date')}" />
					
						<g:sortableColumn property="cash" title="${message(code: 'person.cash.label', default: 'Cash')}" />

                        <th>${message(code: 'person.bases.count.label', default: 'Base count')}</th>

						<g:sortableColumn property="enabled" title="${message(code: 'person.enabled.label', default: 'Enabled')}" />
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${personInstanceList}" status="i" var="personInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">

                        <td><g:link action="show" class="person-btn-list" id="${personInstance.id}">${fieldValue(bean: personInstance, field: "username")}</g:link></td>
					
						<td><g:formatDate date="${personInstance.created}" format="dd-MM-yyyy HH-mm-ss"/></td>

                        <td>${fieldValue(bean: personInstance, field: "cash")}</td>

                        <g:set var="baseCount" value="${personInstance.bases?.size()}"/>
                        <td>${baseCount}</td>
					
						<td>${fieldValue(bean: personInstance, field: "enabled")}</td>
					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${personInstanceCount ?: 0}" />
			</div>
		</div>
	</body>
</html>
