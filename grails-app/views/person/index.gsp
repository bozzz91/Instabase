<%@ page import="instabase.Node" %>

<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'person.label', default: 'Person')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
        <script src="<g:createLinkTo dir='js' file='jstree.min.js'/>"></script>
        <link rel="stylesheet" type="text/css" href="<g:createLinkTo dir='css' file='themes/default/style.min.css'/>" />
        <script type="text/javascript">
            $(function () {
                $("#introspection_tree").jstree({
                    "plugins" : ["themes", "json_data", "ui", "wholerow", "contextmenu", "state"],
                    "state" : {
                        "key" : "instabasePersonTree"
                    },
                    "contextmenu" : {
                        "select_node" : true,
                        "items" : function (node) {
                            return {
                                "Open": {
                                    "separator_before": false,
                                    "separator_after": false,
                                    "label": "Open",
                                    "action": function () {
                                        window.location.href = '${createLink(controller: 'node', action: 'show')}' + '/' + node.id.substring(5);
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
			</ul>
		</div>

        <div id="introspection_tree"></div>

        <div id="dialog" title="<g:message code='dialog.info.title'/>" style="display: none"></div>
	</body>
</html>
