<%@ page import="instabase.Person" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <title><g:message code="person.show.label"/></title>
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
                    <g:message code="person.list.label"/>
                </g:link>
            </li>
            <li>
                <g:link class="create" action="create">
                    <g:message code="person.create.label"/>
                </g:link>
            </li>
        </ul>
    </div>

    <div id="show-person" class="content scaffold-show" role="main">
        <h1><g:message code="person.show.label"/></h1>
        <g:if test="${flash.message}">
            <div class="message" role="status">${flash.message}</div>
        </g:if>
        <ol class="property-list person">

            <g:if test="${personInstance?.username}">
                <li class="fieldcontain">
                    <span id="username-label" class="property-label">
                        <g:message code="person.username.label" default="E-Mail (Login)"/>
                    </span>
                    <span class="property-value" aria-labelledby="username-label">
                        <g:fieldValue bean="${personInstance}" field="username"/>
                    </span>
                </li>
            </g:if>

            <g:if test="${personInstance?.fullName}">
                <li class="fieldcontain">
                    <span id="fullName-label" class="property-label">
                        <g:message code="person.fullName.label" default="Full Name"/>
                    </span>
                    <span class="property-value" aria-labelledby="fullName-label">
                        <g:fieldValue bean="${personInstance}" field="fullName"/>
                    </span>
                </li>
            </g:if>

            <g:if test="${personInstance?.cash}">
                <li class="fieldcontain">
                    <span id="cash-label" class="property-label">
                        <g:message code="person.cash.label" default="Cash"/>
                    </span>
                    <span class="property-value" aria-labelledby="cash-label">
                        <g:fieldValue bean="${personInstance}" field="cash"/>
                    </span>
                </li>
            </g:if>

            <g:if test="${personInstance?.created}">
                <li class="fieldcontain">
                    <span id="created-label" class="property-label">
                        <g:message code="person.created.label" default="Created"/>
                    </span>
                    <span class="property-value" aria-labelledby="created-label">
                        <g:formatDate date="${personInstance?.created}"/>
                    </span>
                </li>
            </g:if>

            <g:if test="${personInstance?.accountExpired}">
                <li class="fieldcontain">
                    <span id="accountExpired-label" class="property-label">
                        <g:message code="person.accountExpired.label" default="Account Expired"/>
                    </span>
                    <span class="property-value" aria-labelledby="accountExpired-label">
                        <g:formatBoolean boolean="${personInstance?.accountExpired}"/>
                    </span>
                </li>
            </g:if>

            <g:if test="${personInstance?.accountLocked}">
                <li class="fieldcontain">
                    <span id="accountLocked-label" class="property-label">
                        <g:message code="person.accountLocked.label" default="Account Locked"/>
                    </span>
                    <span class="property-value" aria-labelledby="accountLocked-label">
                        <g:formatBoolean boolean="${personInstance?.accountLocked}"/>
                    </span>
                </li>
            </g:if>

            <g:if test="${personInstance?.enabled}">
                <li class="fieldcontain">
                    <span id="enabled-label" class="property-label">
                        <g:message code="person.enabled.label" default="Enabled"/>
                    </span>
                    <span class="property-value" aria-labelledby="enabled-label">
                        <g:formatBoolean boolean="${personInstance?.enabled}"/>
                    </span>
                </li>
            </g:if>

            <g:if test="${personInstance?.passwordExpired}">
                <li class="fieldcontain">
                    <span id="passwordExpired-label" class="property-label">
                        <g:message code="person.passwordExpired.label" default="Password Expired"/>
                    </span>
                    <span class="property-value" aria-labelledby="passwordExpired-label">
                        <g:formatBoolean boolean="${personInstance?.passwordExpired}"/>
                    </span>
                </li>
            </g:if>

            <g:if test="${payments}">
                <li class="fieldcontain">
                    <span id="payments-label" class="property-label">
                        <g:message code="person.payments.label" default="Payments"/>
                    </span>
                    <g:each in="${payments}" var="p">
                        <span class="property-value" aria-labelledby="payments-label">
                            <g:link controller="payment" action="show" id="${p.id}">${p?.encodeAsHTML()}</g:link>
                        </span>
                    </g:each>
                </li>
            </g:if>

        </ol>
        <g:form url="[resource: personInstance, action: 'delete']" method="DELETE">
            <fieldset class="buttons">
                <g:link class="edit" action="edit" resource="${personInstance}">
                    <g:message code="default.button.edit.label" default="Edit"/>
                </g:link>
                <g:actionSubmit class="delete" action="delete"
                                value="${message(code: 'default.button.delete.label', default: 'Delete')}"
                                onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"/>
            </fieldset>
        </g:form>
    </div>
</body>
</html>
