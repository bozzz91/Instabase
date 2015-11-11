<script>
    function customMenu(node) {
        var id = node.id.substring(5);
        var items = {
            'createNode': {
                "separator_before": false,
                "separator_after": false,
                'label': "Create node",
                'action': function () {
                    window.location.href = '${createLink(controller: 'node', action: 'create')}' + '/?node.id=' + id;
                }
            },
            'createBase': {
                "separator_before": false,
                "separator_after": false,
                'label': "Create base",
                'action': function () {
                    window.location.href = '${createLink(controller: 'base', action: 'create')}' + '/?node.id=' + id;
                }
            },
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
            delete items.createNode;
            delete items.createBase;
            delete items.openNode;
        } else {
            delete items.openBase;
        }

        return items;
    }

    $(function () {
        $("#introspection_tree").jstree({
            "plugins" : ["themes", "json_data", "ui", "wholerow", "checkbox", "contextmenu", "state"],
            "checkbox" : {
                "keep_selected_style" : false,
                "whole_node": false,
                "cascade": "down",
                "three_state": false
            },
            "state" : {
                "key" : "instabaseTree"
            },
            "contextmenu" : {
                "select_node" : false,
                "items" : customMenu
            },
            "core" : {
                'check_callback': true,
                'dblclick_toggle': true,
                'data': {
                    'url': "${createLink(action: 'generateFileList')}",
                    'data': function (node) {
                        return {'nodeId': node.id.substring(5)};
                    }
                }
            }
        });
    });
</script>