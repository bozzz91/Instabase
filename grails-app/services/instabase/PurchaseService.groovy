package instabase

import grails.transaction.Transactional

@Transactional
class PurchaseService {

    def purchaseBases(String ids, Person p) {
        def bases = [] as Set
        def usedNodes = [] as Set
        ids.split(',').each {
            Long id = it.substring(5) as Long
            if (!usedNodes.contains(id)) {
                if (it.startsWith('node_')) {
                    Node node = Node.findById(id)
                    Map result = collectBasesFromNode(node)
                    usedNodes.addAll(result.nodes)
                    bases.addAll(result.bases)
                } else if (it.startsWith('base_')) {
                    Base base = Base.findById(id)
                    bases << base.id
                    usedNodes << base.id
                }
            }
        }
        def totalCost = 0.0
        def validate = bases.every { Long baseId ->
            Base base = Base.findById(baseId)
            totalCost += base.cost
            if (p.cash < totalCost) {
                return false
            }
            p.addToBases(base)
        }

        if (validate) {
            p.save();
            return "OK"
        } else {
            return "Недостаточно средств"
        }
    }

    private def collectBasesFromNode = { Node node ->
        //node = Node.get(node.id)
        def bases = [] as Set
        def nodes = [] as Set
        nodes << node.id
        if (node instanceof Base) {
            bases << node.id
        } else {
            node.nodes.each { Node innerNode ->
                Map result = collectBasesFromNode(innerNode)
                bases.addAll(result.bases)
                nodes.addAll(result.nodes)
            }
        }
        return [bases: bases, nodes: nodes]
    }
}
