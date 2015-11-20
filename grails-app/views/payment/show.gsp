<%@ page import="instabase.Payment" %>

<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'payment.label', default: 'Payment')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#show-payment" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="list" action="index"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="show-payment" class="content scaffold-show" role="main">
			<h1><g:message code="default.show.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<ol class="property-list payment">

                <sec:ifAllGranted roles="ROLE_ADMIN">
				<g:if test="${paymentInstance?.owner}">
				<li class="fieldcontain">
					<span id="owner-label" class="property-label">
                        <g:message code="payment.owner.label" default="Owner" />
                    </span>
                    <span class="property-value" aria-labelledby="owner-label">
                        <g:link controller="person" action="show" id="${paymentInstance?.owner?.id}">
                            ${paymentInstance?.owner?.encodeAsHTML()}
                        </g:link>
                    </span>
				</li>
				</g:if>
                </sec:ifAllGranted>
			
				<g:if test="${paymentInstance?.amount}">
				<li class="fieldcontain">
					<span id="amount-label" class="property-label">
                        <g:message code="payment.amount.label" default="Amount" />
                    </span>
                    <span class="property-value" aria-labelledby="amount-label">
                        <g:fieldValue bean="${paymentInstance}" field="amount"/>
                    </span>
				</li>
				</g:if>
			
				<g:if test="${paymentInstance?.creationDate}">
				<li class="fieldcontain">
					<span id="creationDate-label" class="property-label">
                        <g:message code="payment.creationDate.label" default="Creation Date" />
                    </span>
                    <span class="property-value" aria-labelledby="creationDate-label">
                        <g:formatDate date="${paymentInstance?.creationDate}" />
                    </span>
				</li>
				</g:if>
			
				<g:if test="${paymentInstance?.payDate}">
				<li class="fieldcontain">
					<span id="payDate-label" class="property-label">
                        <g:message code="payment.payDate.label" default="Pay Date" />
                    </span>
                    <span class="property-value" aria-labelledby="payDate-label">
                        <g:formatDate date="${paymentInstance?.payDate}" />
                    </span>
				</li>
				</g:if>
			
				<g:if test="${paymentInstance?.state}">
				<li class="fieldcontain">
					<span id="state-label" class="property-label">
                        <g:message code="payment.state.label" default="State" />
                    </span>
                    <span class="property-value" aria-labelledby="state-label">
                        <g:fieldValue bean="${paymentInstance}" field="state"/>
                    </span>
				</li>
				</g:if>

                <g:if test="${paymentInstance?.state == Payment.State.WAIT && paymentInstance.owner == user}">
                <li class="fieldcontain">
                    <iframe frameborder="0" allowtransparency="true" scrolling="no" src="https://money.yandex.ru/embed/shop.xml?account=410013703278079&label=${paymentInstance.id}&quickpay=shop&payment-type-choice=on&writer=seller&targets=Пополнение+баланса&default-sum=${paymentInstance.amount}&button-text=01&mail=on&successURL=" width="450" height="198">
                    </iframe>
                </li>
                </g:if>
			</ol>
            <sec:ifAllGranted roles="ROLE_ADMIN">
			<g:form url="[resource:paymentInstance, action:'delete']" method="DELETE">
				<fieldset class="buttons">
					<g:link class="edit" action="edit" resource="${paymentInstance}">
                        <g:message code="default.button.edit.label" default="Edit" />
                    </g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</fieldset>
			</g:form>
            </sec:ifAllGranted>
		</div>
	</body>
</html>
