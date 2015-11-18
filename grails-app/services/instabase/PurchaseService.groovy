package instabase

import grails.converters.JSON
import grails.transaction.Transactional

@Transactional
class PurchaseService {

    def purchaseBases(Map params, Person p) {
        def bases = [] as Set
        def usedNodes = [] as Set
        String ids = params.ids
        Boolean pre = params.pre ? Boolean.valueOf("${params.pre}") : true
        if (pre) {
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
        } else {
            bases = ids.split(',').collect { it as Long }
        }
        def totalCost = 0.0
        def count = 0
        def basesToBuy = []
        def validate = bases.every { Long baseId ->
            Base base = Base.findById(baseId)
            if (p.bases.contains(base)) {
                return true
            }

            totalCost += base.cost
            if (p.cash < totalCost) {
                return false
            }
            count++
            if (!pre) {
                PersonBase.create(p, base)
            } else {
                basesToBuy << base.id
            }
        }
        if (count == 0) {
            return [
                state: 0,
                text: "Все выбранные базы уже куплены"
            ] as JSON
        }

        if (validate) {
            if (!pre) {
                p.cash -= totalCost
                p.save(failOnError: true);
                return [
                    cost: totalCost,
                    state: 2,
                    count: count,
                    text: "Базы успешно куплены"
                ] as JSON
            } else {
                return [
                    cost: totalCost,
                    state: 1,
                    count: count,
                    text: basesToBuy.join(',')
                ] as JSON
            }
        } else {
            return  [
                state: 0,
                text: "Недостаточно средств"
            ] as JSON
        }
    }

    private def collectBasesFromNode(Node node) {
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
