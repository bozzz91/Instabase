<script>
    function submitPurchase() {
        var checked_ids = $("#introspection_tree").jstree(true).get_selected();
        if (!checked_ids || checked_ids.length == 0) {
            openDialog("Не выбрано ни одной базы");
            return;
        }
        $.ajax({
            'url': '${createLink(action: 'purchase')}',
            'data': { 'ids': checked_ids.toString()},
            'success': function(data) {
                console.log('success purchasing. ' + data);
                if (data != "OK") {
                    openDialog(data);
                } else {
                    openDialog("Базы успешно куплены");
                }
            },
            'error': function(data) {
                if (data.status == 401) {
                    window.location.href = '${createLink(uri: '/login')}'
                } else {
                    openDialog('Ошибка: ' + data);
                }
            }
        });
    }
</script>