<%@ page import="instabase.Node" %>

<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'node.label', default: 'Node')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
        <script src="<g:createLinkTo dir='js' file='jstree.min.js'/>"></script>
        <link rel="stylesheet" type="text/css" href="<g:createLinkTo dir='css' file='themes/default/style.min.css'/>" />
        <script type="text/javascript">
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
                        "select_node" : true,
                        "items" : function (node) {
                            var id = node.id.substring(5);
                            return {
                                "Create node": {
                                    "separator_before": false,
                                    "separator_after": false,
                                    "label": "Create node",
                                    "action": function () {
                                        window.location.href = '${createLink(action: 'create')}' + '/?node.id=' + id;
                                    }
                                },
                                "Create base": {
                                    "separator_before": false,
                                    "separator_after": false,
                                    "label": "Create base",
                                    "action": function () {
                                        window.location.href = '${createLink(controller: 'base', action: 'create')}' + '/?node.id=' + id;
                                    }
                                },
                                "Open": {
                                    "separator_before": false,
                                    "separator_after": false,
                                    "label": "Open",
                                    "action": function () {
                                        window.location.href = '${createLink(action: 'show')}' + '/' + id;
                                    }
                                }
                            };
                        }
                    },
                    "core" : {
                        'data': {
                            'url': "${createLink(action: 'generateFileList')}",
                            'data': function (node) {
                                return {'nodeId': node.id.substring(5)};
                            }
                        }
                    }
                });
            });

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
                        openDialog('Ошибка: ' + data);
                    }
                });
            }

            function openDialog(text) {
                $("#dialog").text(text).dialog({
                    modal: true,
                    buttons: {
                        'Ok': function() {
                            $(this).dialog("close");
                        }
                    }
                });
            }
        </script>
	</head>
	<body>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
                <li><a class="list" href="${createLink(controller: 'node')}"><g:message code="node.bases.label"/></a></li>
                <li><a class="create" href="#" onclick="submitPurchase()"><g:message code="purchase.label"/></a></li>
			</ul>
		</div>

        <div id="introspection_tree">
        </div>

        <div id="dialog" title="Basic dialog" style="display: none"></div>
	</body>
</html>
