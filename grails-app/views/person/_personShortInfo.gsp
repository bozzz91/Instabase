<%@ page import="instabase.Person" %>

<body>

<div id="show-person">
    <ul>

        <g:if test="${user?.username}">
            <li>
                <g:message code="person.username.short.label" default="Login"/> : <g:fieldValue bean="${user}" field="username"/>
            </li>
        </g:if>
		<br>
        <g:if test="${user?.cash}">
            <li>
                <g:message code="person.cash.label" default="Cash"/> : <g:fieldValue bean="${user}" field="cash"/>
            </li>
        </g:if>

        <li>
            <g:set var="baseCount" value="${user.bases?.size()}"/>
            <g:message code="person.bases.count.label" default="Base count"/> : ${baseCount}
        </li>
    </ul>
    <g:form controller="payment" action="create" method="GET">
        <fieldset class="buttons">
            <g:actionSubmit class="create" action="create"
                            value="${message(code: 'default.button.payment.create.label', default: 'Пополнить баланс')}"/>
        </fieldset>
    </g:form>
</div>
</body>