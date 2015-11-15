<script type="text/javascript">
    function customMenu(node) {
        var id = node.id.substring(5);
        var items = {
            'openNode': {
                "separator_before": false,
                "separator_after": false,
                'label': "Open node",
                'action': function () {
                    window.location.href = '${createLink(controller: 'node', action: 'show')}' + '/' + id;
                }
            },
            'openBase': {
                'label': "Open base",
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
                        return {'nodeId': node.id.substring(5)};
                    }
                }
            }
        });
    });
</script>