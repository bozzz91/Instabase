
<%@ page import="instabase.Person" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<title><g:message code="person.list.label"/></title>
	</head>
	<body>
        <div class="nav" role="navigation">
            <ul>
                <li>
                    <a class="home" href="${createLink(uri: '/')}">
                        <g:message code="default.home.label"/>
                    </a>
                </li>
                <li>
                    <g:link class="create" action="create">
                        <g:message code="person.create.label"/>
                    </g:link>
                </li>
            </ul>
        </div>
		<div id="list-person" class="content scaffold-list" role="main">
			<h1><g:message code="person.list.label"/></h1>
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

                        <td>${personInstance.bases?.size()}</td>
					
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
