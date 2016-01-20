
<%@ page import="instabase.Payment" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'payment.label', default: 'Payment')}" />
		<title><g:message code="payment.list.label"/></title>
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
                        <g:message code="payment.create.label"/>
                    </g:link>
                </li>
			</ul>
		</div>
		<div id="list-payment" class="content scaffold-list" role="main">
			<h1><g:message code="payment.list.label"/></h1>
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

                        <g:if test="${paymentInstance?.state == Payment.State.WAIT}">
						    <td><g:link action="show" class="pay-btn-list" id="${paymentInstance.id}">Оплатить</g:link></td>
                        </g:if>
                        <g:else>
                            <td><g:link action="show" class="show-btn-list" id="${paymentInstance.id}">Просмотр</g:link></td>
                        </g:else>
					
						<td>${fieldValue(bean: paymentInstance, field: "amount")}</td>
					
						<td><g:formatDate date="${paymentInstance.creationDate}" format="dd-MM-yyyy HH-mm-ss"/></td>
					
						<td><g:formatDate date="${paymentInstance.payDate}" format="dd-MM-yyyy HH-mm-ss"/></td>
					
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
