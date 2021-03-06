<%@ page import="instabase.Node" %>

<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<title><g:message code="node.show.label"/></title>
	</head>
	<body>
        <g:render template="simpleNav"/>
		<div id="show-node" class="content scaffold-show" role="main">
			<h1><g:message code="node.show.label"/></h1>
			<g:if test="${flash.message}">
			    <div class="message" role="status">${flash.message}</div>
			</g:if>
			<ol class="property-list node">
				<g:if test="${nodeInstance?.name}">
				<li class="fieldcontain">
					<span id="name-label" class="property-label">
                        <g:message code="node.name.label" default="Name" />
                    </span>
                    <span class="property-value" aria-labelledby="name-label">
                        <g:fieldValue bean="${nodeInstance}" field="name"/>
                    </span>
				</li>
				</g:if>
			
				<g:if test="${nodeInstance?.level}">
				<li class="fieldcontain">
					<span id="level-label" class="property-label">
                        <g:message code="node.level.label" default="Level" />
                    </span>
                    <span class="property-value" aria-labelledby="level-label">
                        <g:fieldValue bean="${nodeInstance}" field="level"/>
                    </span>
				</li>
				</g:if>

                <li class="fieldcontain">
                    <span id="cost-label" class="property-label">
                        <g:message code="base.cost.label" default="Cost" />
                    </span>
                    <span class="property-value" aria-labelledby="cost-label">
                        <g:fieldValue bean="${nodeInstance}" field="cost"/>
                    </span>
                </li>
			
				<g:if test="${nodeInstance?.parent}">
				<li class="fieldcontain">
					<span id="parent-label" class="property-label">
                        <g:message code="node.parent.label" default="Parent" />
                    </span>
                    <span class="property-value" aria-labelledby="parent-label">
                        <g:link controller="node" action="show" id="${nodeInstance?.parent?.id}">
                            ${nodeInstance?.parent?.name?.encodeAsHTML()}
                        </g:link>
                    </span>
				</li>
				</g:if>
			
				<g:if test="${nodeInstance?.nodes}">
				<li class="fieldcontain">
					<span id="nodes-label" class="property-label">
                        <g:message code="node.nodes.label" default="Nodes" />
                    </span>
                    <g:each in="${nodeInstance.nodes}" var="n">
						<span class="property-value" aria-labelledby="nodes-label">
                            <g:link controller="node" action="show" id="${n.id}">
                                ${n?.name?.encodeAsHTML()}
                            </g:link>
                        </span>
                    </g:each>
				</li>
				</g:if>
			
			</ol>
			<g:form url="[resource:nodeInstance, action:'delete']" method="DELETE">
				<fieldset class="buttons">
					<g:link class="edit" action="edit" resource="${nodeInstance}" params="['parent': nodeInstance?.parent?.id]">
                        <g:message code="default.button.edit.label" default="Edit" />
                    </g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
