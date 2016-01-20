<div class="nav" role="navigation">
    <ul>
        <li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
        <sec:ifLoggedIn>
            <li><a class="create" href="#" onclick="submitPurchase()"><g:message code="purchase.label"/></a></li>
            <li><a class="upgrade" href="#" onclick="upgradeBase()"><g:message code="upgrade.label"/></a></li>
        </sec:ifLoggedIn>
    </ul>
</div>