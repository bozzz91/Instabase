<%@ page import="org.springframework.validation.FieldError" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <title><g:message code="register.label"/></title>
</head>

<body>

    <div class="nav" role="navigation">
        <ul>
            <sec:ifAllGranted roles="ROLE_ADMIN">
            <li>
                <g:link class="list" action="list">
                    <g:message code="all.person.list.label"/>
                </g:link>
            </li>
            </sec:ifAllGranted>
        </ul>
    </div>

    <div id="create-person" class="content scaffold-create" role="main">
        <h1><g:message code="register.label"/></h1>
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
        <g:form url="[resource: personInstance, action: 'save']">
            <fieldset class="form">
                <g:render template="form"/>
                <g:submitButton name="create" class="save" value="${message(code: 'register.button.label', default: 'Register')}"/>
            </fieldset>
        </g:form>
    </div>
</body>
</html>
