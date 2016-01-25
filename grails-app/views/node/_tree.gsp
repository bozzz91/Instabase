<script>
    function customMenu(node) {
        var id = node.id.substring(5);
        var items = {
            <sec:ifAnyGranted roles="ROLE_ADMIN">
            'createNode': {
                "separator_before": false,
                "separator_after": false,
                'label': "Добавить категорию",
                'action': function () {
                    window.location.href = '${createLink(controller: 'node', action: 'create')}' + '/?parent=' + id;
                }
            },
            'createBase': {
                "separator_before": false,
                "separator_after": false,
                'label': "Создать базу в текущем каталоге",
                'action': function () {
                    window.location.href = '${createLink(controller: 'base', action: 'create')}' + '/?parent=' + id;
                }
            },
            'openNode': {
                "separator_before": false,
                "separator_after": false,
                'label': "Просмотр категории",
                'action': function () {
                    window.location.href = '${createLink(controller: 'node', action: 'show')}' + '/' + id;
                }
            },
            </sec:ifAnyGranted>
            'openBase': {
                'label': "Открыть базу",
                'action': function () {
                    window.location.href = '${createLink(controller: 'base', action: 'show')}' + '/' + id;
                }
            }
        };

        if (node.original.file) {
            delete items.createNode;
            delete items.createBase;
            delete items.openNode;
        } else {
            delete items.openBase;
        }

        return items;
    }

    function downloadBase(id) {
        window.location.href = "${createLink(controller: 'base', action: 'download')}/" + id;
    }

    var checkAgain = true;

    $(function () {
        $("#introspection_tree").jstree({
            "plugins" : ["themes", "json_data", "ui", "wholerow", "checkbox", "contextmenu", "state"],
            "checkbox" : {
                "keep_selected_style" : false,
                "whole_node": false,
                //"cascade": "up+down",
                "three_state": true
            },
            "state" : {
                "key" : "instabaseNotFreeTree${category}",
                "ttl": 300000 //5 min to clean state
            },
            "contextmenu" : {
                "select_node" : false,
                "items" : customMenu
            },
            "core" : {
                'check_callback': true,
                'dblclick_toggle': true,
                'data': {
                    'url': "${createLink(action: 'generateFileList', params: ['category': category])}",
                    'data': function (node) {
                        return {'nodeId': node.id.substring(5)};
                    },
                    'success': function(data) {
                        if (checkAgain) {
                            if (data.length == 0) {
                                $('#cat-empty-div').show();
                            }
                            checkAgain = false;
                        }
                    }
                }
            }
        });
    });
</script>