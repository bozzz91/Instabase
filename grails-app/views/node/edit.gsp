<%@ page import="org.springframework.validation.FieldError; instabase.Node" %>

<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<title><g:message code="node.edit.label"/></title>
	</head>
	<body>
        <g:render template="simpleNav"/>
		<div id="edit-node" class="content scaffold-edit" role="main">
			<h1><g:message code="node.edit.label"/></h1>
			<g:if test="${flash.message}">
			    <div class="message" role="status">${flash.message}</div>
			</g:if>
			<g:hasErrors bean="${nodeInstance}">
			<ul class="errors" role="alert">
				<g:eachError bean="${nodeInstance}" var="error">
				<li <g:if test="${error in FieldError}">data-field-id="${error.field}"</g:if>>
                    <g:message error="${error}"/>
                </li>
				</g:eachError>
			</ul>
			</g:hasErrors>
			<g:form url="[resource:nodeInstance, action:'update']" method="PUT" >
				<g:hiddenField name="version" value="${nodeInstance?.version}" />
				<fieldset class="form">
					<g:render template="form"/>
				</fieldset>
				<fieldset class="buttons">
                    <g:actionSubmit class="save" action="update" value="${message(code: 'default.button.update.label', default: 'Update')}" />
                    <g:link class="closeEdit" controller="node" action="show" id="${nodeInstance.id}">${message(code: 'default.button.close.label', default: 'Close')}</g:link>
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
