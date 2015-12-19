package instabase

import grails.converters.JSON
import grails.transaction.Transactional

@Transactional
class PurchaseService {

    /**
     * @return JSON response:
     * 1) successfully prepare for buy:
     *    {
     *      cost: 1235, -- price
     *      state: 1, -- 1 is success
     *      count: 5, -- base count
     *      text: '1,2,3,6,67' -- base IDs
     *    }
     * 2) error while prepare
     *    {
     *      state: 0, -- 0 is error
     *      errorType: 1, -- 0 is low balance, 1 is all bases already bought
     *      text: "Все выбранные базы уже куплены" -- msg about error to show user
     *    }
     * 3) successfully buy:
     *    {
     *      cost: 1235, -- price
     *      state: 2, -- 2 is success order
     *      count: 5, -- bought base count
     *      text: 'Базы успешно куплены' -- msg to show for user
     *    }
     * */
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

        if (validate) {
            if (count == 0) {
                return [
                    state: 0, //error
                    errorType: 1, //all bases already bought
                    text: "Все выбранные базы уже куплены"
                ] as JSON
            }
            if (!pre) {
                p.cash -= totalCost
                p.save(failOnError: true);
                return [
                    cost: totalCost,
                    state: 2, //success bought
                    count: count,
                    text: "Базы успешно куплены"
                ] as JSON
            } else {
                return [
                    cost: totalCost,
                    state: 1, //success prepare
                    count: count,
                    text: basesToBuy.join(',')
                ] as JSON
            }
        } else {
            return  [
                state: 0, //error
                errorType: 0, //low balance
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
