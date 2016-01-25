<%@ page import="instabase.Base" %>

<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<title><g:message code="base.show.label"/></title>
	</head>
	<body>
		<a href="#show-base" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li>
                    <a class="home" href="${createLink(uri: '/')}">
                        <g:message code="default.home.label"/>
                    </a>
                </li>
				<li>
                    <g:link class="list" controller="node" action="index">
                        <g:message code="base.list.label"/>
                    </g:link>
                </li>
                <sec:ifAllGranted roles="ROLE_ADMIN">
				<li>
                    <g:link class="create" action="create">
                        <g:message code="base.create.label"/>
                    </g:link>
                </li>
                </sec:ifAllGranted>
			</ul>
		</div>
		<div id="show-base" class="content scaffold-show" role="main">
			<h1><g:message code="base.show.label"/></h1>
			<g:if test="${flash.message}">
			    <div class="message" role="status">${flash.message}</div>
			</g:if>
			<ol class="property-list base">
			
				<g:if test="${baseInstance?.name}">
				<li class="fieldcontain">
					<span id="name-label" class="property-label">
                        <g:message code="base.name.label" default="Name" />
                    </span>
                    <span class="property-value" aria-labelledby="name-label">
                        <g:fieldValue bean="${baseInstance}" field="name"/>
                    </span>
				</li>
				</g:if>
			
				<g:if test="${baseInstance?.level}">
				<li class="fieldcontain">
					<span id="level-label" class="property-label">
                        <g:message code="base.level.label" default="Level" />
                    </span>
                    <span class="property-value" aria-labelledby="level-label">
                        <g:fieldValue bean="${baseInstance}" field="level"/>
                    </span>
				</li>
				</g:if>
			
				<g:if test="${baseInstance?.parent}">
				<li class="fieldcontain">
					<span id="parent-label" class="property-label">
                        <g:message code="base.parent.label" default="Parent" />
                    </span>
                    <span class="property-value" aria-labelledby="parent-label">
                        <g:link controller="node" action="show" id="${baseInstance?.parent?.id}">
                            ${baseInstance?.parent?.name?.encodeAsHTML()}
                        </g:link>
                    </span>
				</li>
				</g:if>
			
				<g:if test="${baseInstance?.creationDate}">
				<li class="fieldcontain">
					<span id="creationDate-label" class="property-label">
                        <g:message code="base.creationDate.label" default="Creation Date" />
                    </span>
                    <span class="property-value" aria-labelledby="creationDate-label">
                        <g:formatDate date="${baseInstance?.creationDate}" format="dd-MM-yyyy HH:mm:ss" />
                    </span>
				</li>
				</g:if>

                <g:if test="${baseInstance?.updateDate}">
                    <li class="fieldcontain">
                        <span id="updateDate-label" class="property-label">
                            <g:message code="base.updateDate.label" default="Update Date" />
                        </span>
                        <span class="property-value" aria-labelledby="updateDate-label">
                            <g:formatDate date="${baseInstance?.updateDate}" format="dd-MM-yyyy HH:mm:ss" />
                        </span>
                    </li>
                </g:if>

                <li class="fieldcontain">
                    <span id="cost-label" class="property-label">
                        <g:message code="base.cost.label" default="Cost" />
                    </span>
                    <span class="property-value" aria-labelledby="cost-label">
                        <g:fieldValue bean="${baseInstance}" field="cost"/>р.
                    </span>
                </li>

                <g:if test="${baseInstance?.ver}">
                    <li class="fieldcontain">
                        <span id="ver-label" class="property-label">
                            <g:message code="base.ver.label" default="Ver" />
                        </span>
                        <span class="property-value" aria-labelledby="ver-label">
                            <g:fieldValue bean="${baseInstance}" field="ver"/>
                        </span>
                    </li>
                </g:if>

				<g:if test="${baseInstance?.contentName}">
				<li class="fieldcontain">
					<span id="content-label" class="property-label">
                        <g:message code="base.content.label" default="Content Name" />
                    </span>
                    <span class="property-value" aria-labelledby="content-label">
                        <g:link controller="base" action="download" resource="${baseInstance}">
                            ${baseInstance?.contentName?.encodeAsHTML()}
                        </g:link>
                    </span>
				</li>
				</g:if>

                <sec:ifAllGranted roles="ROLE_ADMIN">
                <li class="fieldcontain">
                    <span id="path-label" class="property-label">
                        <g:message code="base.path.label" default="Path" />
                    </span>
                    <span class="property-value" aria-labelledby="path-label">
                        <g:fieldValue bean="${baseInstance}" field="filePath"/>
                    </span>
                </li>
                </sec:ifAllGranted>
			
			</ol>
            <sec:ifAllGranted roles="ROLE_ADMIN">
			<g:form url="[resource:baseInstance, action:'delete']" method="DELETE">
				<fieldset class="buttons">
					<g:link class="edit" action="edit" resource="${baseInstance}" params="['parent': baseInstance?.parent?.id]">
                        <g:message code="default.button.edit.label" default="Edit" />
                    </g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</fieldset>
			</g:form>
            </sec:ifAllGranted>
		</div>
	</body>
</html>
