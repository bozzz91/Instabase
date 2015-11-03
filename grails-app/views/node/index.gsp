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
                    "plugins" : ["themes", "json_data", "ui", "wholerow", "contextmenu", "state"],
                    /*"checkbox" : {
                        "keep_selected_style" : false,
                        "whole_node": false
                    },*/
                    "state" : {
                        "key" : "instabaseTree"
                    },
                    "contextmenu" : {
                        "select_node" : false,
                        "items" : function (node) {
                            var tree = $("#introspection_tree").jstree(true);
                            return {
                                "Create node": {
                                    "separator_before": false,
                                    "separator_after": false,
                                    "label": "Create node",
                                    "action": function (obj) {
                                        console.log(obj);
                                        node = tree.create_node(node);
                                    }
                                },
                                "Open": {
                                    "separator_before": false,
                                    "separator_after": false,
                                    "label": "Open",
                                    "action": function (obj) {
                                        console.log(obj);
                                        window.location.href = '${createLink(action: 'show')}' + '/' + node.id;
                                    }
                                }
                            };
                        }
                    },
                    "core" : {
                        'data': {
                            'url': "${createLink(action: 'generateFileList')}",
                            'data': function (node) {
                                return {'nodeId': node.id};
                            }
                        }
                    }
                });
            });

            function submitPurchase() {
                var checked_ids = $("#introspection_tree").jstree(true).get_selected();
                console.log('checked: ' + checked_ids);
                $.ajax({
                    'url': '${createLink(action: 'purchase')}',
                    'data': { 'ids': checked_ids.toString()},
                    'success': function(data) {
                        console.log('success purchasing. ' + data);
                    },
                    'error': function() {
                        console.log('error');
                    }
                });
            }
        </script>
	</head>
	<body>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
                <li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
                <li><a class="create" href="#" onclick="submitPurchase()">Purchase</a></li>
			</ul>
		</div>

        <div id="introspection_tree">
        </div>
	</body>
</html>
