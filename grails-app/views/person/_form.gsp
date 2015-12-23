<%@ page import="instabase.Person" %>

<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'username', 'error')} required">
    <label for="username">
        <g:message code="person.username.label" default="Email (login)"/>
        <span class="required-indicator">*</span>
    </label>
    <g:if test="${personInstance?.id}">
        <g:fieldValue bean="${personInstance}" field="username"/>
    </g:if>
    <g:else>
        <g:field type="email" name="username" required="" value="${personInstance?.username}"/>
    </g:else>
</div>

<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'password', 'error')} required">
    <label for="password">
        <g:message code="person.password.label" default="Password"/>
        <span class="required-indicator">*</span>
    </label>
    <g:passwordField name="password" required="" value="${personInstance?.password}"/>
</div>

<g:if test="${!personInstance?.id}">
<div class="fieldcontain required">
    <label for="confirmPassword">
        <g:message code="person.confirmPassword.label" default="Confirm Password"/>
        <span class="required-indicator">*</span>
    </label>
    <g:passwordField name="confirmPassword" required="" value=""/>
</div>
</g:if>

<g:if test="${personInstance?.id}">
<div class="fieldcontain required">
    <label for="enabled">
        <g:message code="person.enabled.label" default="Confirm Password"/>
        <span class="required-indicator">*</span>
    </label>
    <g:select from="${['true','false']}" name="enabled" required="" value="${personInstance?.enabled}"/>
</div>
</g:if>
