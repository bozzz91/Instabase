<%@ page import="instabase.Payment" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'payment.label', default: 'Payment')}" />
		<title><g:message code="payment.edit.label"/></title>
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
                    <g:link class="list" action="index">
                        <g:message code="payment.all.list.label" />
                    </g:link>
                </li>
			</ul>
		</div>
		<div id="edit-payment" class="content scaffold-edit" role="main">
			<h1><g:message code="payment.edit.label"/></h1>
			<g:if test="${flash.message}">
			    <div class="message" role="status">${flash.message}</div>
			</g:if>
			<g:hasErrors bean="${paymentInstance}">
			<ul class="errors" role="alert">
				<g:eachError bean="${paymentInstance}" var="error">
				<li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>>
                    <g:message error="${error}"/>
                </li>
				</g:eachError>
			</ul>
			</g:hasErrors>
			<g:form url="[resource:paymentInstance, action:'update']" method="PUT" >
				<g:hiddenField name="version" value="${paymentInstance?.version}" />
				<fieldset class="form">
					<g:render template="form"/>
				</fieldset>
				<fieldset class="buttons">
					<g:actionSubmit class="save" action="update" value="${message(code: 'default.button.update.label', default: 'Update')}" />
                    <g:link class="closeEdit" controller="payment" action="show" id="${paymentInstance.id}">${message(code: 'default.button.close.label', default: 'Close')}</g:link>
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
