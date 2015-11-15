<%@ page import="instabase.Person" %>

<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'username', 'error')} required">
    <label for="username">
        <g:message code="person.username.label" default="Username"/>
        <span class="required-indicator">*</span>
    </label>
    <g:textField name="username" required="" value="${personInstance?.username}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'password', 'error')} required">
    <label for="password">
        <g:message code="person.password.label" default="Password"/>
        <span class="required-indicator">*</span>
    </label>
    <g:textField name="password" required="" value="${personInstance?.password}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'email', 'error')} required">
    <label for="email">
        <g:message code="person.email.label" default="Email"/>
        <span class="required-indicator">*</span>
    </label>
    <g:field type="email" name="email" required="" value="${personInstance?.email}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'fullName', 'error')} required">
    <label for="fullName">
        <g:message code="person.fullName.label" default="Full Name"/>
        <span class="required-indicator">*</span>
    </label>
    <g:textField name="fullName" required="" value="${personInstance?.fullName}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'cash', 'error')} required">
    <label for="cash">
        <g:message code="person.cash.label" default="Cash"/>
        <span class="required-indicator">*</span>
    </label>
    <g:field name="cash" value="${fieldValue(bean: personInstance, field: 'cash')}" required=""/>

</div>

<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'created', 'error')} ">
    <label for="created">
        <g:message code="person.created.label" default="Created"/>

    </label>
    <g:datePicker name="created" precision="day" value="${personInstance?.created}" default="none"
                  noSelection="['': '']"/>

</div>

<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'accountExpired', 'error')} ">
    <label for="accountExpired">
        <g:message code="person.accountExpired.label" default="Account Expired"/>

    </label>
    <g:checkBox name="accountExpired" value="${personInstance?.accountExpired}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'accountLocked', 'error')} ">
    <label for="accountLocked">
        <g:message code="person.accountLocked.label" default="Account Locked"/>

    </label>
    <g:checkBox name="accountLocked" value="${personInstance?.accountLocked}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'enabled', 'error')} ">
    <label for="enabled">
        <g:message code="person.enabled.label" default="Enabled"/>

    </label>
    <g:checkBox name="enabled" value="${personInstance?.enabled}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'passwordExpired', 'error')} ">
    <label for="passwordExpired">
        <g:message code="person.passwordExpired.label" default="Password Expired"/>

    </label>
    <g:checkBox name="passwordExpired" value="${personInstance?.passwordExpired}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'payments', 'error')} ">
    <label for="payments">
        <g:message code="person.payments.label" default="Payments"/>

    </label>

    <ul class="one-to-many">
        <g:each in="${personInstance?.payments ?}" var="p">
            <li><g:link controller="payment" action="show" id="${p.id}">${p?.encodeAsHTML()}</g:link></li>
        </g:each>
        <li class="add">
            <g:link controller="payment" action="create"
                    params="['person.id': personInstance?.id]">${message(code: 'default.add.label', args: [message(code: 'payment.label', default: 'Payment')])}</g:link>
        </li>
    </ul>

</div>

