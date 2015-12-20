
<%@ page import="instabase.Payment" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'payment.label', default: 'Payment')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#list-payment" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="list-payment" class="content scaffold-list" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
				<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
			<thead>
					<tr>
					
						<th></th>
					
						<g:sortableColumn property="amount" title="${message(code: 'payment.amount.label', default: 'Amount')}" />
					
						<g:sortableColumn property="creationDate" title="${message(code: 'payment.creationDate.label', default: 'Creation Date')}" />
					
						<g:sortableColumn property="payDate" title="${message(code: 'payment.payDate.label', default: 'Pay Date')}" />
					
						<g:sortableColumn property="state" title="${message(code: 'payment.state.label', default: 'State')}" />
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${paymentInstanceList}" status="i" var="paymentInstance">
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td><g:link action="show" class="pay-btn-list" id="${paymentInstance.id}">Оплатить</g:link></td>
					
						<td>${fieldValue(bean: paymentInstance, field: "amount")}</td>
					
						<td><g:formatDate date="${paymentInstance.creationDate}" /></td>
					
						<td><g:formatDate date="${paymentInstance.payDate}" /></td>
					
						<td>${fieldValue(bean: paymentInstance, field: "state")}</td>
					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${paymentInstanceCount ?: 0}" />
			</div>
		</div>
	</body>
</html>
