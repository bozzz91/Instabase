<!DOCTYPE html>
<html>
	<head>
		<title><g:if env="development">Payment</g:if><g:else>Error</g:else></title>
		<meta name="layout" content="main">
		<g:if env="development"><asset:stylesheet src="errors.css"/></g:if>
	</head>
	<body>
		<g:if env="development">
            <ul class="errors">
                <li>${text}</li>
            </ul>
			<g:renderException exception="${exception}" />
		</g:if>
		<g:else>
			<ul class="errors">
				<li>${text}</li>
			</ul>
		</g:else>
	</body>
</html>
