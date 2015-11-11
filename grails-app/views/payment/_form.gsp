<%@ page import="instabase.Payment" %>



<div class="fieldcontain ${hasErrors(bean: paymentInstance, field: 'owner', 'error')} required">
	<label for="owner">
		<g:message code="payment.owner.label" default="Owner" />
		<span class="required-indicator">*</span>
	</label>
	<g:select id="owner" name="owner.id" from="${instabase.Person.list()}" optionKey="id" required="" value="${paymentInstance?.owner?.id}" class="many-to-one"/>

</div>

<div class="fieldcontain ${hasErrors(bean: paymentInstance, field: 'amount', 'error')} required">
	<label for="amount">
		<g:message code="payment.amount.label" default="Amount" />
		<span class="required-indicator">*</span>
	</label>
	<g:field name="amount" value="${fieldValue(bean: paymentInstance, field: 'amount')}" required=""/>

</div>

<div class="fieldcontain ${hasErrors(bean: paymentInstance, field: 'creationDate', 'error')} required">
	<label for="creationDate">
		<g:message code="payment.creationDate.label" default="Creation Date" />
		<span class="required-indicator">*</span>
	</label>
	<g:datePicker name="creationDate" precision="day"  value="${paymentInstance?.creationDate}"  />

</div>

<div class="fieldcontain ${hasErrors(bean: paymentInstance, field: 'payDate', 'error')} required">
	<label for="payDate">
		<g:message code="payment.payDate.label" default="Pay Date" />
		<span class="required-indicator">*</span>
	</label>
	<g:datePicker name="payDate" precision="day"  value="${paymentInstance?.payDate}"  />

</div>

<div class="fieldcontain ${hasErrors(bean: paymentInstance, field: 'state', 'error')} required">
	<label for="state">
		<g:message code="payment.state.label" default="State" />
		<span class="required-indicator">*</span>
	</label>
	<g:select name="state" from="${instabase.Payment$State?.values()}" keys="${instabase.Payment$State.values()*.name()}" required="" value="${paymentInstance?.state?.name()}" />

</div>

