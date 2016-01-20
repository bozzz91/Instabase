<%@ page import="instabase.Person; instabase.Payment" %>

<sec:ifAllGranted roles="ROLE_ADMIN">
<div class="fieldcontain ${hasErrors(bean: paymentInstance, field: 'owner', 'error')} required">
	<label for="owner">
		<g:message code="payment.owner.label" default="Owner" />
		<span class="required-indicator">*</span>
	</label>
	<g:select id="owner" name="owner.id" from="${Person.findById(params.parent as Long)}" optionKey="id" optionValue="username" required="" value="${paymentInstance?.owner?.id}" class="many-to-one"/>
</div>
</sec:ifAllGranted>

<div class="fieldcontain ${hasErrors(bean: paymentInstance, field: 'amount', 'error')} required">
	<label for="amount">
		<g:message code="payment.amount.label" default="Amount" />
		<span class="required-indicator">*</span>
	</label>
	<g:field type="number" name="amount" value="${fieldValue(bean: paymentInstance, field: 'amount') ?: ((params.defaultAmount as Integer) > 10 ? params.defaultAmount : 10)}" required=""/>
</div>

<sec:ifAllGranted roles="ROLE_ADMIN">
    <div class="fieldcontain ${hasErrors(bean: paymentInstance, field: 'state', 'error')} required">
        <label for="state">
            <g:message code="payment.state.label" default="State" />
            <span class="required-indicator">*</span>
        </label>
        <g:select name="state" from="${instabase.Payment$State?.values()}" keys="${instabase.Payment$State.values()*.name()}" required="" value="${paymentInstance?.state?.name()}" />
    </div>
</sec:ifAllGranted>
<sec:ifNotGranted roles="ROLE_ADMIN">
    <sec:ifAllGranted roles="ROLE_USER">
        <!--div class="fieldcontain ${hasErrors(bean: paymentInstance, field: 'state', 'error')} required">
            <label for="state">
                <g:message code="payment.state.label" default="State" />
                <span class="required-indicator">*</span>
            </label>
            <g:fieldValue id="state" bean="${paymentInstance}" field="state"/>
        </div-->
    </sec:ifAllGranted>
</sec:ifNotGranted>

