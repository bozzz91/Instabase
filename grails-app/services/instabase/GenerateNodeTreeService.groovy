package instabase

import grails.converters.JSON
import grails.transaction.Transactional
import org.codehaus.groovy.grails.web.mapping.LinkGenerator

import java.text.DecimalFormat

@Transactional
class GenerateNodeTreeService {

    LinkGenerator grailsLinkGenerator

    def generateTree(Map params, Person personOwner = null, boolean viewMode = false) {
        String nodeId = params.nodeId
        String category = params.category

        Node currentNode
        if (!nodeId || nodeId == "#") {
            currentNode = Node.findByLevelAndName(0, category)
        } else {
            currentNode = Node.get(nodeId as Integer)
        }

        def boughtBases = [] as Set
        if (personOwner) {
            personOwner = Person.get(personOwner.id)
            personOwner.bases.each { Base base ->
                boughtBases << base.id
                Node parent = base.parent
                while (parent) {
                    boughtBases << parent.id
                    parent = Node.get(parent.id).parent
                }
            }
        }
        Set<Node> nodes = currentNode?.nodes
        if (nodes) {
            if (personOwner && viewMode) {
                nodes = nodes.findAll { it.id in boughtBases }
            }
            nodes = nodes.sort { it.name }
        }

        return nodesToJson(nodes, boughtBases, viewMode)
    }

    private def nodesToJson(def nodes, Set boughtBases = null, boolean viewMode = false) {
        if (!nodes) {
            return ([] as JSON)
        }
        List result = []
        nodes.each {
            result << nodeToJson(it as Node, boughtBases, viewMode)
        }
        return (result as JSON)
    }

    private def nodeToJson (Node node, Set boughtBases = null, boolean viewMode = false) {
        def idPrefix = 'node_'
        def icon = grailsLinkGenerator.resource(dir: 'images', file: 'folder.png')
        def text = node.name
        def disabled = false
        DecimalFormat df = new DecimalFormat("##.##")
        def isBase = node instanceof Base
        if (isBase) {
            Base base = (Base) node
            idPrefix = 'base_'
            icon = grailsLinkGenerator.resource(dir: 'images', file: 'db.png')
            if (text.endsWith('.txt') || text.endsWith('.dat')) {
                text = text.substring(0, text.lastIndexOf('.'));
            }
            text += ' (' + base.updateDate.format("dd-MM-yyyy") + ')'
            if (viewMode) {
                text += " <a class='downloadLink' onclick='downloadBase(${base.id})' href='#'>Скачать</a>"
            } else {
                if (boughtBases != null) {
                    if (boughtBases.contains(base.id)) {
                        text += " <a class='downloadLink boughtBase' onclick='downloadBase(${base.id})' href='#'>(Куплено) Скачать</a>"
                        disabled = true
                    } else {
                        text += " <a class='purchaseLink' onclick='submitPurchase(\"${idPrefix}${base.id}\")' href='#'>Купить (${df.format(base.cost)}р)</a>"
                    }
                }
            }
        } else {
            if (!viewMode) {
                text += " [Базы: ${node.totalBaseCount} шт. на ${df.format(node.cost)} р]"
            }
        }

        return [
                id: idPrefix + node.id,
                text: text,
                state : [
                        'opened' : node.level in  [0,1],
                        'selected' : false,
                        'disabled' : disabled
                ],
                icon: icon,
                children: !node.isEmpty(),
                file: isBase
        ]
    }
}
