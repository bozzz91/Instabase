<div class="nav" role="navigation">
    <ul>
        <li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
        <li><a class="list" href="${createLink(controller: 'node')}"><g:message code="node.bases.label"/></a></li>
        <sec:ifLoggedIn>
            <li><a class="create" href="#" onclick="submitPurchase()"><g:message code="purchase.label"/></a></li>
        </sec:ifLoggedIn>
    </ul>
</div>