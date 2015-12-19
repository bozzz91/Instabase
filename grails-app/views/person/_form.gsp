<%@ page import="instabase.Person" %>

<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'username', 'error')} required">
    <label for="username">
        <g:message code="person.username.label" default="Email (login)"/>
        <span class="required-indicator">*</span>
    </label>
    <g:field type="email" name="username" required="" value="${personInstance?.username}"/>
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
<div class="fieldcontain ${hasErrors(bean: personInstance, field: 'fullName', 'error')}">
    <label for="fullName">
        <g:message code="person.fullName.label" default="Full Name"/>
        <span class="required-indicator">*</span>
    </label>
    <g:textField name="fullName" required="" value="${personInstance?.fullName}"/>
</div>
</g:if>
