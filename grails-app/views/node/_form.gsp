<%@ page import="instabase.Node" %>

<div class="fieldcontain ${hasErrors(bean: nodeInstance, field: 'name', 'error')} required">
	<label for="name">
		<g:message code="node.name.label" default="Name" />
		<span class="required-indicator">*</span>
	</label>
    <g:if test="${nodeInstance?.id}">
        <g:fieldValue bean="${nodeInstance}" field="name"/>
    </g:if>
    <g:else>
        <g:field type="text" name="name" required="*" value="${nodeInstance?.name}"/>
    </g:else>
</div>

<div class="fieldcontain">
    <label for="level">
        <g:message code="node.level.label" default="Level" />
    </label>
    <g:fieldValue id="level" bean="${nodeInstance}" field="level"/>
</div>

<div class="fieldcontain ${hasErrors(bean: nodeInstance, field: 'parent', 'error')} ">
	<label for="parent">
		<g:message code="node.parent.label" default="Parent" />
	</label>
	<g:select id="parent" name="parent.id" from="${Node.findById(params.parent as Long)}" optionValue="name" optionKey="id" value="${nodeInstance?.parent?.id ?: params.parent as Long}" class="many-to-one" noSelection="['null': '']"/>
</div>

<div class="fieldcontain ${hasErrors(bean: nodeInstance, field: 'nodes', 'error')} ">
	<label for="nodes">
		<g:message code="node.nodes.label" default="Nodes" />
	</label>
	
    <ul class="one-to-many">
        <g:each in="${nodeInstance?.nodes?}" var="n">
            <li><g:link controller="node" action="show" id="${n.id}">${n?.name?.encodeAsHTML()}</g:link></li>
        </g:each>
        <g:if test="${nodeInstance?.id}">
        <li class="add">
            <g:link controller="node" action="create" params="['parent': nodeInstance?.id]">
                ${message(code: 'default.add.label', args: [message(code: 'node.label', default: 'Node')])}
            </g:link>
        </li>
        </g:if>
        <g:else>
            <li>No nodes</li>
        </g:else>
    </ul>
</div>