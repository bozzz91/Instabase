<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>${title}</title>
</head>

<body>
    <p style="visibility:hidden;">true</p>
    <p style="width:500px;text-align:center;margin:0 auto;">
        <g:if test="${success}">
            <b>Спасибо! Ваше сообщение отправлено.</b>
        </g:if>
        <g:else>
            <b>Ошибка отправки!</b> Попробуйте отправить письмо позднее.
        </g:else>
    </p>
    <meta http-equiv="refresh" content="3; url=http://instabase.su"/>
</body>
</html>