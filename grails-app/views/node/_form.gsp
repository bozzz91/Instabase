<%@ page import="instabase.Node" %>

<div class="fieldcontain ${hasErrors(bean: nodeInstance, field: 'name', 'error')} required">
	<label for="name">
		<g:message code="node.name.label" default="Name" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="name" required="" value="${nodeInstance?.name}"/>

</div>

<div class="fieldcontain ${hasErrors(bean: nodeInstance, field: 'type', 'error')} required">
	<label for="type">
		<g:message code="node.type.label" default="Type" />
		<span class="required-indicator">*</span>
	</label>
	<g:select name="type" from="${nodeInstance.constraints.type.inList}" required="" value="${nodeInstance?.type}" valueMessagePrefix="node.type"/>

</div>

<div class="fieldcontain ${hasErrors(bean: nodeInstance, field: 'parent', 'error')} ">
	<label for="parent">
		<g:message code="node.parent.label" default="Parent" />
		
	</label>
	<g:select id="parent" name="parent.id" from="${Node.findById(params.node?.id)}" optionKey="id" value="${nodeInstance?.parent?.id ?: params.node?.id}" class="many-to-one" noSelection="['null': '']"/>
</div>

<div class="fieldcontain ${hasErrors(bean: nodeInstance, field: 'bases', 'error')} ">
	<label for="bases">
		<g:message code="node.bases.label" default="Bases" />
		
	</label>
	
<ul class="one-to-many">
<g:each in="${nodeInstance?.bases?}" var="b">
    <li><g:link controller="base" action="show" id="${b.id}">${b?.encodeAsHTML()}</g:link></li>
</g:each>
<li class="add">
<g:link controller="base" action="create" params="['node.id': nodeInstance?.id]">${message(code: 'default.add.label', args: [message(code: 'base.label', default: 'Base')])}</g:link>
</li>
</ul>


</div>

<div class="fieldcontain ${hasErrors(bean: nodeInstance, field: 'nodes', 'error')} ">
	<label for="nodes">
		<g:message code="node.nodes.label" default="Nodes" />
		
	</label>
	
<ul class="one-to-many">
<g:each in="${nodeInstance?.nodes?}" var="n">
    <li><g:link controller="node" action="show" id="${n.id}">${n?.encodeAsHTML()}</g:link></li>
</g:each>
<li class="add">
<g:link controller="node" action="create" params="['node.id': nodeInstance?.id]">${message(code: 'default.add.label', args: [message(code: 'node.label', default: 'Node')])}</g:link>
</li>
</ul>


</div>

