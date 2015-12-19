<script>
    function submitPurchase(id) {
        var checked_ids = id;
        if (!checked_ids) {
            checked_ids = $("#introspection_tree").jstree(true).get_selected();
        }
        if (!checked_ids || checked_ids.length == 0) {
            openDialog("Не выбрано ни одной базы");
            return;
        }
        $.ajax({
            'url': '${createLink(action: 'purchase')}',
            'data': { 'ids': checked_ids.toString()},
            'success': function(data) {
                console.log('success pre purchasing. ' + data);
                if (data.state != 1) {
                    //если нет денег на счету то errorType == 0
                    if (data.errorType == 0) {
                        $("#dialog").text(data.text).dialog({
                            modal: true,
                            buttons: {
                                'Ok': function() {
                                    $(this).dialog("close");
                                },
                                'Пополнить баланс' : function() {
                                    window.location.href = '${createLink(uri: '/payment/create')}'
                                }
                            }
                        });
                    } else {
                        openDialog(data.text);
                    }
                } else {
                    var text = "Купить базы (" + data.count + " шт) за " + data.cost + "р?";
                    $("#dialog").text(text).dialog({
                        modal: true,
                        buttons: {
                            'Да': function() {
                                $.ajax({
                                    'url': '${createLink(action: 'purchase', params: ['pre': false])}',
                                    'data': { 'ids': data.text},
                                    'success': function(data) {
                                        console.log('success purchasing. ' + data);
                                        if (data.state != 2) {
                                            openDialog(data);
                                        } else {
                                            openDialog(data.text);
                                            $("#introspection_tree").jstree(true).refresh();
                                        }
                                    },
                                    'error': function(data) {
                                        if (data.status == 401) {
                                            window.location.href = '${createLink(uri: '/login')}'
                                        } else {
                                            openDialog('Ошибка: ' + data.text);
                                        }
                                    }
                                });
                            },
                            'Отмена' : function() {
                                $(this).dialog("close");
                            }
                        }
                    });
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