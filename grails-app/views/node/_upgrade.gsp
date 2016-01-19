<script>
    function upgradeBase(id, fromV, fromDate, toV, toDate, cost) {
        var checked_ids = id;
        var informationText = '';
        if (!checked_ids) {
            checked_ids = $("#introspection_tree").jstree(true).get_selected();
            informationText = null;
        } else {
            informationText += 'Обновить базу или скачать предыдущую купленную версию?<br/>';
            informationText += 'Купленная версия: v' + fromV + ' от ' + fromDate + '<br/>';
            informationText += 'Новая версия: v' + toV + ' от ' + toDate + '<br/>';
            informationText += 'Стоимость обновления: ' + cost + 'р.';
        }
        if (!checked_ids || checked_ids.length == 0) {
            openDialog("Не выбрано ни одной базы");
            return;
        }

        if (informationText == null) {
            doUpgrade(checked_ids);
        } else {
            $("#dialog").html(informationText).dialog({
                modal: true,
                width: 600,
                buttons: {
                    'Скачать старую версию': function() {
                        downloadBase(id.substring(5));
                        $(this).dialog("close");
                    },
                    'Обновить' : function() {
                        doUpgrade(checked_ids);
                    }
                }
            });
        }
    }

    function doUpgrade(checked_ids) {
        $.ajax({
            'url': '${createLink(controller: 'node', action: 'upgrade')}',
            'data': { 'ids': checked_ids.toString()},
            'success': function(data) {
                console.log('success pre upgrade. ' + data);
                if (data.state != 1) {
                    //если нет денег на счету то errorType == 0
                    if (data.errorType == 0) {
                        $("#dialog").html(data.text).dialog({
                            modal: true,
                            buttons: {
                                'Ok': function() {
                                    $(this).dialog("close");
                                },
                                'Пополнить баланс' : function() {
                                    window.location.href = '${createLink(uri: '/payment/create')}' + '?defaultAmount=' + data.count
                                }
                            }
                        });
                    } else {
                        openDialog(data.text);
                    }
                } else {
                    var text = "Обновить базы (" + data.count + " шт) за " + data.cost + "р?";
                    $("#dialog").text(text).dialog({
                        modal: true,
                        buttons: {
                            'Да': function() {
                                $.ajax({
                                    'url': '${createLink(controller: 'node', action: 'upgrade', params: ['pre': false])}',
                                    'data': { 'ids': data.text},
                                    'success': function(data) {
                                        console.log('success upgrading. ' + data);
                                        if (data.state != 2) {
                                            openDialog(data);
                                        } else {
                                            openDialog(data.text, true);
                                            //$("#introspection_tree").jstree(true).refresh();
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