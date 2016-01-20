<%@ page import="org.springframework.validation.FieldError; instabase.Person" %>

<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <title><g:message code="person.edit.label"/></title>
</head>

<body>

    <div class="nav" role="navigation">
        <ul>
            <li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
            <li><g:link class="list" action="index"><g:message code="person.list.label"/></g:link></li>
            <li><g:link class="create" action="create"><g:message code="person.create.label"/></g:link></li>
        </ul>
    </div>

    <div id="edit-person" class="content scaffold-edit" role="main">
        <h1><g:message code="person.edit.label"/></h1>
        <g:if test="${flash.message}">
            <div class="message" role="status">${flash.message}</div>
        </g:if>
        <g:hasErrors bean="${personInstance}">
            <ul class="errors" role="alert">
                <g:eachError bean="${personInstance}" var="error">
                    <li <g:if test="${error in FieldError}">data-field-id="${error.field}"</g:if>>
                        <g:message error="${error}"/>
                    </li>
                </g:eachError>
            </ul>
        </g:hasErrors>
        <g:form url="[resource: personInstance, action: 'update']" method="PUT">
            <g:hiddenField name="version" value="${personInstance?.version}"/>
            <fieldset class="form">
                <g:render template="form"/>
            </fieldset>
            <fieldset class="buttons">
                <g:actionSubmit class="save" action="update" value="${message(code: 'default.button.update.label', default: 'Update')}"/>
                <g:link class="closeEdit" controller="person" action="show" id="${personInstance.id}">${message(code: 'default.button.close.label', default: 'Close')}</g:link>
            </fieldset>
        </g:form>
    </div>
</body>
</html>
