<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ru" lang="ru">
<head>
    <title>Обратная связь,сбор базы инстаграм,база инстаграм</title>
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="keywords" content="сбор базы инстаграм,база инстаграм,база аккаунтов инстаграм"/>
	<meta name="description" content="Базы Instagram по всем регионам и городам РФ. Мы предоставляем для Вас только актуальные и качественные базы - обновление каждую неделю! Скачайте базы инстаграм в один клик. Продвигатей аккаунты в Instagram вместе с InstaBase.su"/>
	<link rel="shortcut icon" href="/img/favicon1.ico" type="image/x-icon">
	<link rel="apple-touch-icon" sizes="57x57" href="/img/apple-icon-57x57.png">
	<link rel="apple-touch-icon" sizes="60x60" href="/img/apple-icon-60x60.png">
	<link rel="apple-touch-icon" sizes="72x72" href="/img/apple-icon-72x72.png">
	<link rel="apple-touch-icon" sizes="76x76" href="/img/apple-icon-76x76.png">
	<link rel="apple-touch-icon" sizes="114x114" href="/img/apple-icon-114x114.png">
	<link rel="apple-touch-icon" sizes="120x120" href="/img/apple-icon-120x120.png">
	<link rel="apple-touch-icon" sizes="144x144" href="/img/apple-icon-144x144.png">
	<link rel="apple-touch-icon" sizes="152x152" href="/img/apple-icon-152x152.png">
	<link rel="apple-touch-icon" sizes="180x180" href="/img/apple-icon-180x180.png">
	<link rel="icon" type="image/png" sizes="192x192" href="/img/android-icon-192x192.png">
	<link rel="icon" type="image/png" sizes="32x32" href="/img/favicon-32x32.png">
	<link rel="icon" type="image/png" sizes="96x96" href="/img/favicon-96x96.png">
	<link rel="icon" type="image/png" sizes="16x16" href="/img/favicon-16x16.png">
	<meta name="msapplication-TileImage" content="img/ms-icon-144x144.png">
	<meta name="msapplication-TileColor" content="#ffffff">
	<link rel="stylesheet" type="text/css" href="/css/style.css" />
	<link rel="stylesheet" type="text/css" href="/css/feedbackform.css" />
	<!--menu-->
	<link rel="stylesheet" href="/css/menu-1.css">
	<link rel="stylesheet" type="text/css" href="/css/normalize.css" />
	<link rel="stylesheet" type="text/css" href="/css/component.css" />
	<script src="/js/modernizr.custom.25376.js"></script>
	<!--slider-->
	<link rel="stylesheet" type="text/css" href="/css/slider-1.css" />
    <link rel="stylesheet" type="text/css" href="/css/slider-2.css" />
	<script type="text/javascript" src="/js/modernizr.custom.79639.js"></script>
	<noscript>
		<link rel="stylesheet" type="text/css" href="/css/slider-styleNoJS.css" />
	</noscript>
</head>
<body>
	<div id="all">
		<div id="main">
			<div id="perspective" class="perspective effect-rotatetop">
				<div class="container">
					<div class="wrapper"><!-- wrapper needed for scroll -->

                        <!-- header -->
                        <g:render template="header"/>
                        <!-- header -->

                        <!-- header -->
                        <g:render template="menu"/>
                        <!-- header -->

						<div id="wrap">
							<div class="utp">
								<h1>Обратная связь</h1>
								<div class="sale inline-block"><p>Базы <br>от 9 руб.</p></div>
							</div>
							<div class="divider1"></div>
							<div class="main-content">
								<div class="main-content-items">
									<div class="inline-block borders">
										<p>
											<p style="font-size:16pt;">Тех. поддержка и Ваши вопросы/предложения</p>
											<form id="feedbackform" action="/feedbackForm" method="post">
												<span>Поля отмеченные * являются обязательными</span><br><br>
												<input type="text" name="name" required placeholder="Ваше имя *" x-autocompletetype="name" pattern="^[А-Яа-яЁё\s]+$" title="Введите имя правильно"><br>
												<input type="text" name="email" required placeholder="Ваш email/логин *" x-autocompletetype="email" pattern="^([a-z0-9\._\-]+)@([a-z0-9\.\-]+)(\.[a-z]{2,})$" title="Введите email/логин правильно"><br>
												<select name="type_mes">
													<option>По какому вопросу?</option>
													<option>Техниченая поддержка</option>
													<option>Общие вопросы</option>
													<option>Предложение</option>
													<option>Другое</option>
												</select><br>
												<textarea rows="5" type="text" name="message" stoke required placeholder="Текст сообщения *" pattern="/[^0-9a-z '\.A-ZА-Яа-я--]/" title="Текст сообщения может содержать только цифрф и русские буквы" x-autocompletetype="txt"></textarea><br>
												<input type="submit" id="send" value="Отправить" alt="Отправить" title="Отправить">
											</form>
										</p>
									</div>
								</div>
							</div>
						</div>
					</div><!-- wrapper -->
				</div><!-- /container -->

                <!-- menu bottom -->
                <g:render template="menu_bottom"/>
                <!-- menu bottom -->

			</div><!-- /perspective -->
		</div>
	</div>

    <!-- footer -->
    <g:render template="footer"/>
    <!-- footer -->
	
	<!--slider-->
	<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>
    <script type="text/javascript" src="/js/jquery.ba-cond.min.js"></script>
    <script type="text/javascript" src="/js/jquery.slitslider.js"></script>
	<script type="text/javascript" src="/js/classie.js"></script>
	<script type="text/javascript" src="/js/menu.js"></script>
</body>
</html>