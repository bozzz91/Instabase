package instabase

import grails.converters.JSON
import grails.transaction.Transactional
import org.codehaus.groovy.grails.web.mapping.LinkGenerator

@Transactional
class GenerateNodeTreeService {

    LinkGenerator grailsLinkGenerator

    def generateTree = { String nodeId, Person owner = null ->
        if (!nodeId || nodeId == "#") {
            return nodesToJson(Node.findAll("from Node n where n.type = 'root'"))
        }
        Node currentNode = Node.get(nodeId as Integer)

        def nodesToRender = [] as Set
        if (owner) {
            owner = Person.get(owner.id)
            owner.bases.each { Base base ->
                nodesToRender << base.id
                Node parent = base.parent
                while (parent) {
                    nodesToRender << parent.id
                    parent = Node.get(parent.id).parent
                }
            }
        }
        Set<Node> nodes = currentNode.nodes
        if (nodes) {
            if (owner) {
                nodes = nodes.findAll { it.id in nodesToRender }
            }
            nodes = nodes.sort { it.name }
        }

        return nodesToJson(nodes)
    }

    private def nodesToJson = { def nodes ->
        if (!nodes) {
            return ([] as JSON)
        }
        List result = []
        nodes.each {
            result << nodeToJson(it as Node)
        }
        return (result as JSON)
    }

    private def nodeToJson = { Node node ->
        def idPrefix = 'node_'
        def icon = grailsLinkGenerator.resource(dir: 'images', file: 'folder.png')
        def isBase = node instanceof Base
        if (isBase) {
            idPrefix = 'base_'
            icon = grailsLinkGenerator.resource(dir: 'images', file: 'db.png')
        }
        return [
                id: idPrefix + node.id,
                text: node.name,
                state : [
                        'opened' : false,
                        'selected' : false
                ],
                icon: icon,
                children: !node.isEmpty(),
                file: isBase
        ]
    }
}
