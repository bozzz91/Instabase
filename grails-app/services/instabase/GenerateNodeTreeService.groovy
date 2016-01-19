package instabase

import grails.converters.JSON
import grails.transaction.Transactional
import org.codehaus.groovy.grails.web.mapping.LinkGenerator

import java.text.DecimalFormat

@Transactional
class GenerateNodeTreeService {

    LinkGenerator grailsLinkGenerator

    def generateTree(Map params, Person personOwner = null, def viewMode = false, def free = false) {
        String nodeId = params.nodeId
        String category = params.category

        Node currentNode
        if (!nodeId || nodeId == "#") {
            currentNode = Node.findByLevelAndName(0, category)
        } else {
            currentNode = Node.get(nodeId as Integer)
        }

        def boughtBases = [] as Set
        if (personOwner && !free) {
            personOwner = Person.get(personOwner.id)
            personOwner.bases.each { Base base ->
                boughtBases << base.id
                Node parent = base.parent
                while (parent) {
                    boughtBases << parent.id
                    parent = Node.get(parent.id).parent
                }
            }
        } else if (free) {
            Base.findAllByFree(true).each { Base base ->
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
            if (personOwner && viewMode || free) {
                nodes = nodes.findAll { it.id in boughtBases }
            }
            if (!free) {
                nodes = nodes.findAll { it.cost > 0.0d }
            }
            nodes = nodes.sort { it.name }
        }

        return nodesToJson(nodes, personOwner, boughtBases, viewMode || free)
    }

    private def nodesToJson(def nodes, Person personOwner, Set boughtBases = null, def viewMode = false) {
        if (!nodes) {
            return ([] as JSON)
        }
        List result = []
        nodes.each {
            result << nodeToJson(it as Node, personOwner, boughtBases, viewMode)
        }
        return (result as JSON)
    }

    private def nodeToJson (Node node, Person personOwner, Set boughtBases = null, def viewMode = false) {
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
            text = text - '.txt'

            if (viewMode) {
                if (personOwner?.id && PersonBase.exists(personOwner.id, base.id)) {
                    PersonBase pb = PersonBase.get(personOwner.id, base.id)
                    if (pb.baseVersion == base.ver) {
                        text += ' (' + base.updateDate.format("dd-MM-yyyy") + ')'
                        text += " <a class='downloadLink' onclick='downloadBase(${base.id})' href='#'>Скачать</a>"
                    } else {
                        text += ' (' + pb.baseDate.format("dd-MM-yyyy") + ')'
                        text += " <a class='upgradeLink upgradeBase' onclick='upgradeBase(\"${idPrefix}${base.id}\", ${generateUpgradeInfo(pb, base)})' href='#'>Обновить/Скачать</a>"
                    }
                } else {
                    text += ' (' + base.updateDate.format("dd-MM-yyyy") + ')'
                    text += " <a class='downloadLink' onclick='downloadBase(${base.id})' href='#'>Скачать</a>"
                }
            } else {
                text += ' (' + base.updateDate.format("dd-MM-yyyy") + ')'
                if (boughtBases != null) {
                    if (boughtBases.contains(base.id)) {
                        PersonBase pb = PersonBase.get(personOwner.id, base.id)
                        if (pb.baseVersion == base.ver) {
                            text += " <a class='downloadLink boughtBase' onclick='downloadBase(${base.id})' href='#'>(Куплено) Скачать</a>"
                            disabled = true
                        } else {
                            text += " <a class='upgradeLink upgradeBase' onclick='upgradeBase(\"${idPrefix}${base.id}\", ${generateUpgradeInfo(pb, base)})' href='#'>Скачать/Обновить</a>"
                        }
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

    private static String generateUpgradeInfo(PersonBase pb, Base base) {
        return "\"${pb.baseVersion}\", \"${pb.baseDate}\", \"${base.ver}\", \"${base.updateDate}\", \"${base.cost/2}\""
    }
}
