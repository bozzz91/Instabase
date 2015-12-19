<%@ page import="instabase.Person" %>
<!DOCTYPE html>
<!--[if lt IE 7 ]> <html lang="en" class="no-js ie6"> <![endif]-->
<!--[if IE 7 ]>    <html lang="en" class="no-js ie7"> <![endif]-->
<!--[if IE 8 ]>    <html lang="en" class="no-js ie8"> <![endif]-->
<!--[if IE 9 ]>    <html lang="en" class="no-js ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang="en" class="no-js"><!--<![endif]-->
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<title><g:layoutTitle default="Grails"/></title>
		<meta name="viewport" content="width=device-width, maximum-scale=2.0, minimum-scale=1, initial-scale=1 user-scalable=yes">
		<link rel="shortcut icon" href="${assetPath(src: 'favicon1.ico')}" type="image/x-icon">
		<link rel="apple-touch-icon" sizes="57x57" href="${assetPath(src: 'apple-icon-57x57.png')}">
		<link rel="apple-touch-icon" sizes="60x60" href="${assetPath(src: 'apple-icon-60x60.png')}">
		<link rel="apple-touch-icon" sizes="72x72" href="${assetPath(src: 'apple-icon-72x72.png')}">
		<link rel="apple-touch-icon" sizes="76x76" href="${assetPath(src: 'apple-icon-76x76.png')}">
		<link rel="apple-touch-icon" sizes="114x114" href="${assetPath(src: 'apple-icon-114x114.png')}">
		<link rel="apple-touch-icon" sizes="120x120" href="${assetPath(src: 'apple-icon-120x120.png')}">
		<link rel="apple-touch-icon" sizes="144x144" href="${assetPath(src: 'apple-icon-144x144.png')}">
		<link rel="apple-touch-icon" sizes="152x152" href="${assetPath(src: 'apple-icon-152x152.png')}">
		<link rel="apple-touch-icon" sizes="180x180" href="${assetPath(src: 'apple-icon-180x180.png')}">
		<link rel="icon" type="image/png" sizes="192x192"  href="${assetPath(src: 'android-icon-192x192.png')}">
		<link rel="icon" type="image/png" sizes="32x32" href="${assetPath(src: 'favicon-32x32.png')}">
		<link rel="icon" type="image/png" sizes="96x96" href="${assetPath(src: 'favicon-96x96.png')}">
		<link rel="icon" type="image/png" sizes="16x16" href="${assetPath(src: 'favicon-16x16.png')}">
		<link rel="manifest" href="${assetPath(src: 'manifest.json')}">
		<meta name="msapplication-TileColor" content="#ffffff">
		<meta name="msapplication-TileImage" content="${assetPath(src: 'ms-icon-144x144.png')}">
  		<asset:stylesheet src="application.css"/>
		<asset:javascript src="application.js"/>
        <asset:stylesheet src="instabase.css"/>
        <jqui:resources/>
		<g:layoutHead/>
	</head>
	<body>
		<div id="grailsLogo" role="banner">
			<a href="${createLink(url:'/')}"><img src="${createLinkTo(dir: "images", file: "logo.png")}"/></a>
			<div class="header-right">
				<div class="hr-1">
					<p>Не нашли необходимую Вам базу? <br>Тогда мы соберем ее для Вас!</p>
					<a href="#win1" class="btn-order-top" style="color:#000;" title="Заказать базу">Заказать Базу</a>
					<!-- Модальное окно 1 -->
					<a href="#x" class="overlay" id="win1" style="margin:0;"></a>
					<div class="popup">
						<h2>Заказать Базу</h2>
						<p>На указанный Вами Email будет выслан файл базы, а также будет приходить информация о деталях заказа.</p>
						<form action="" class="order-base-form">
							<input type="email" name="email" placeholder="Ваш email *" required pattern="^([a-z0-9\._\-]+)@([a-z0-9\.\-]+)(\.[a-z]{2,})$" title="xxx@xxx.xx"><br>
							<select name="type-order">
								<option>Выберите тип нужной базы</option>
								<option>Сбор по геолокации</option>
								<option>Сбор из Вконтакте</option>
								<option>Сбор по геолокации + фильтр</option>
								<option>Сбор по хэштегам</option>
							</select><br>
							<input type="text" name="city" placeholder="Укажите города/хэштеги через запятую *" pattern="^[А-Яа-яЁё,\s]+$" title="Только русские символы" required><br>
							<input type="text" name="filter" placeholder="Укажите критерии фильтров(если необходимо)" pattern="^[А-Яа-яЁё\s]+$" title="Только русские символы"><br><br>
							К какому времени необходима база?
							<input type="date" name="date"><br>
							<input type="hidden" name="info-form" value="Форма заказа базы">
							<input type="submit" value="Отправить заказ" title="Отправить заказ">
						</form>
						<a class="close" title="Закрыть" href="#close"></a>
					</div>
				</div>
				<div class="hr-2">
					<p>Вы можете заказать продвижение аккаунтов Instagram</p>
					<a href="#win2" class="btn-order-top" style="color:#000;" title="Заказать продвижение">Заказать продвижение</a>
					<!-- Модальное окно 2 -->
					<a href="#x" class="overlay" id="win2" style="margin:0;"></a>
					<div class="popup">
						<h2>Заказать продвижение Instargam</h2>
						<p>На указанный Вами Email будет приходить информация о деталях заказа.</p>
						<form action="" class="order-base-form">
							<input type="email" name="email" placeholder="Ваш email *" required pattern="^([a-z0-9\._\-]+)@([a-z0-9\.\-]+)(\.[a-z]{2,})$" title="xxx@xxx.xx"><br>
							<input type="text" name="account" placeholder="Укажите аккаунты через запятую *" required><br>
							<input type="text" name="wresult" placeholder="Желаемый результат по итогам" pattern="^[А-Яа-яЁё\s]+$" title="Только русские символы"><br><br>
							<textarea rows="5" name="addinfo" placeholder="Дополнительная информация"></textarea>
							<input type="hidden" name="info-form" value="Форма заказа продвижения">
							<input type="submit" value="Отправить заказ" title="Отправить заказ">
						</form>
						<a class="close" title="Закрыть" href="#close"></a>
					</div>
				</div>
			</div>
		</div>
        <div class="left-panel">
            <div class="person-info with-shadow-box">
                <span id='loginLink' style='position: relative;'>
                    <sec:ifLoggedIn>
                        <g:render template="/person/personShortInfo" model="[user: Person.findById(sec.loggedInUserInfo(field: 'id') as Long)]"/>
                        <g:form controller="logout" action="index" method="POST">
                            <fieldset class="buttons">
                                <g:actionSubmit class="logout" action="index"
                                                value="${message(code: 'default.button.logout.label', default: 'Logout')}"/>
                            </fieldset>
                        </g:form>
                    </sec:ifLoggedIn>
                    <sec:ifNotLoggedIn>
                        <ul type="none">
                            <li>
                                <g:link controller="login" action="auth"><div class="btn-action">Войти</div></g:link>
                            </li>
                            <li>
                                <g:link controller="person" action="create"><div class="btn-action">Регистрация</div></g:link>
                            </li>
                        </ul>
                    </sec:ifNotLoggedIn>
                </span>
            </div>
            <div class="navigation-info with-shadow-box">
                <ul type="none">
                    <li><a href="${createLink(controller:'node', action: 'index')}"><div class="btn-action">Список баз</div></a></li>
                    <sec:ifAllGranted roles="ROLE_USER">
                        <li><a href="${createLink(controller:'person', action: 'index')}"><div class="btn-action">Мои базы</div></a></li>
                        <li><a href="${createLink(controller:'payment', action: 'index')}"><div class="btn-action">Мои платежи</div></a></li>
                    </sec:ifAllGranted>
                    <sec:ifAllGranted roles="ROLE_ADMIN">
                        <li style="text-align: center;">
                            <hr/><br/>Меню админа<br/>
                            <a href="${createLink(controller:'payment', action: 'list')}"><div class="btn-action">Все платежи</div></a>
                            <a href="${createLink(controller:'base', action: 'index')}"><div class="btn-action">Все базы</div></a>
                            <hr/>
                            <br/>Управление<br/>
                            <a href="${createLink(controller:'base', action: 'init')}"><div class="btn-action-admin">Инициализация</div></a>
                            <a href="${createLink(uri: '/monitoring')}"><div class="btn-action-admin">Мониторинг</div></a>
                        </li>
                    </sec:ifAllGranted>
                </ul>
            </div>
        </div>
        <div class="workspace with-shadow-box">
		    <g:layoutBody/>
        </div>
		<div class="footer" role="contentinfo">
			<p>InstaBase.su &#169; 2015. Все права защищены.</p>
			<p><a href="/confidential">ПОЛИТИКА КОНФИДЕНЦИАЛЬНОСТИ</a></p>
		</div>
		<div id="spinner" class="spinner" style="display:none;">
            <g:message code="spinner.alt" default="Loading&hellip;"/>
        </div>

        <!-- metric -->
        <g:render template="../metric"/>
        <!-- metric -->
	</body>
</html>
