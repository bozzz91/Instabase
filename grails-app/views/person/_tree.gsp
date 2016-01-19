<script type="text/javascript">
    function customMenu(node) {
        var id = node.id.substring(5);
        var items = {
            <sec:ifAnyGranted roles="ROLE_ADMIN">
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
                'label': "Просмотр базы",
                'action': function () {
                    window.location.href = '${createLink(controller: 'base', action: 'show')}' + '/' + id;
                }
            }
        };

        if (node.original.file) {
            delete items.openNode;
        } else {
            delete items.openBase;
        }

        return items;
    }

    function downloadBase(id) {
        window.location.href = "${createLink(controller: 'base', action: 'download')}/" + id + "?free=${free}";
    }

    var checkAgain = true;

    $(function () {
        $("#introspection_tree").jstree({
            "plugins" : ["themes", "json_data", "ui", "wholerow", "contextmenu", "state"],
            "state" : {
                "key" : "instabasePersonTree"
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
                        return {
                            'nodeId': node.id.substring(5),
                            'free' : ${free}
                        };
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