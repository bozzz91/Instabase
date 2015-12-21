<script>
    function submitPurchase(id) {
        $("#dialog").text('Для покупки баз необходимо войти в систему').dialog({
            title: 'Информация',
            modal: true,
            buttons: {
                'Войти' : function() {
                    window.location.href = '${createLink(uri: '/login/auth')}'
                }
            }
        });
    }
</script>