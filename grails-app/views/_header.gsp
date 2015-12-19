<div class="header-top block">
    <a href="/" title="InstaBase - Актуальные базы аккаунтов Instagram" alt="InstaBase - Актуальные базы аккаунтов Instagram"><div class="logo inline-block"></div></a>
    <div class="nav-login inline-block">
        <sec:ifLoggedIn>
            <a href="/person" class="nav-logged">Мой аккаунт: <sec:username/></a>
        </sec:ifLoggedIn>
        <sec:ifNotLoggedIn>
            <a href="/login/auth" class="nav-enter">Вход</a><a href="/person/create" class="nav-reg">Регистрация</a><br>
        </sec:ifNotLoggedIn>
    </div>
</div>