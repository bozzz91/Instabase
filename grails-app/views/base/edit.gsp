<%@ page import="org.springframework.validation.FieldError; instabase.Base" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<title><g:message code="base.edit.label" /></title>
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
                        <g:message code="base.list.label"/>
                    </g:link>
                </li>
			</ul>
		</div>
		<div id="edit-base" class="content scaffold-edit" role="main">
			<h1><g:message code="base.edit.label"/></h1>
			<g:if test="${flash.message}">
			    <div class="message" role="status">${flash.message}</div>
			</g:if>
			<g:hasErrors bean="${baseInstance}">
			<ul class="errors" role="alert">
				<g:eachError bean="${baseInstance}" var="error">
				<li <g:if test="${error in FieldError}">data-field-id="${error.field}"</g:if>>
                    <g:message error="${error}"/>
                </li>
				</g:eachError>
			</ul>
			</g:hasErrors>
			<g:form url="[resource:baseInstance, action:'update']" method="POST"  enctype="multipart/form-data">
				<g:hiddenField name="version" value="${baseInstance?.version}" />
				<fieldset class="form">
					<g:render template="form"/>
				</fieldset>
				<fieldset class="buttons">
					<g:actionSubmit class="save" action="update" value="${message(code: 'default.button.update.label', default: 'Update')}" />
                    <g:link class="closeEdit" controller="base" action="show" id="${baseInstance.id}">${message(code: 'default.button.close.label', default: 'Close')}</g:link>
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
