<%@ page import="instabase.Base" %>
<%@ page import="instabase.Node" %>

<div class="fieldcontain ${hasErrors(bean: baseInstance, field: 'name', 'error')} required">
	<label for="name">
		<g:message code="base.name.label" default="Name" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="name" required="" value="${baseInstance?.name}"/>
</div>

<div class="fieldcontain">
    <label for="level">
        <g:message code="node.level.label" default="Level" />
    </label>

    <g:fieldValue id="level" bean="${baseInstance}" field="level"/>
</div>

<div class="fieldcontain ${hasErrors(bean: baseInstance, field: 'parent', 'error')} ">
	<label for="parent">
		<g:message code="base.parent.label" default="Parent" />
	</label>
	<g:select id="parent" name="parent.id" from="${Node.findById(params.parent as Long)}" optionValue="name" optionKey="id" value="${baseInstance?.parent?.id ?: params.parent as Long}" class="many-to-one" noSelection="['null': '']"/>
</div>

<div class="fieldcontain ${hasErrors(bean: baseInstance, field: 'creationDate', 'error')} ">
	<label for="creationDate">
		<g:message code="base.creationDate.label" default="Creation Date" />
	</label>
	<g:datePicker name="creationDate" precision="day"  value="${baseInstance?.creationDate}" default="none" noSelection="['': '']" />
</div>

<div class="fieldcontain ${hasErrors(bean: baseInstance, field: 'cost', 'error')} required">
	<label for="cost">
		<g:message code="base.cost.label" default="Cost" />
		<span class="required-indicator">*</span>
	</label>
	<g:field type="number" name="cost" value="${fieldValue(bean: baseInstance, field: 'cost')}" required=""/>
</div>

<div class="fieldcontain ${hasErrors(bean: baseInstance, field: 'filePath', 'error')} required">
	<label for="filePath">
		<g:message code="base.content.label" default="Content" />
		<span class="required-indicator">*</span>
	</label>
	<input type="file" id="filePath" name="filePath" />
</div>

<div class="fieldcontain ${hasErrors(bean: baseInstance, field: 'ver', 'error')} required">
	<label for="ver">
		<g:message code="base.ver.label" default="Ver" />
		<span class="required-indicator">*</span>
	</label>
	<g:field name="ver" type="number" value="${baseInstance.ver}" required=""/>
</div>

