package instabase

import grails.converters.JSON
import grails.transaction.Transactional

import java.text.DecimalFormat

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
     *      count: 234.3, -- how much cash is not enough
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
    private process(Map params, Person p) {
        def bases = [] as Set<Long>
        def usedNodes = [] as Set
        String ids = params.ids
        Boolean pre = params.pre ? Boolean.valueOf("${params.pre}") : true
        Map closures = params.closures

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
                        bases << id
                        usedNodes << id
                    }
                }
            }
        } else {
            bases = ids.split(',').collect { it as Long }
        }
        def totalCost = 0.0
        def count = 0
        def basesToBuy = []

        bases = bases.collect { Long baseId ->
            Base.load(baseId)
        }.findAll { Base base ->
            closures.filterPersonBase.call(p, base)
        }
        bases.each { Base base ->
            totalCost += closures.calcCost.call(base.cost)
            count++
        }

        if (p.cash >= totalCost) {
            bases.each { Base base ->
                if (pre) {
                    basesToBuy << base.id
                } else {
                    closures.processPersonBase.call(p, base)
                }
            }

            if (count == 0) {
                return [
                    state: 0, //error
                    errorType: 1, //all bases already bought
                    text: closures.msgNothingToDo.call()
                ] as JSON
            }
            if (!pre) {
                p.cash -= totalCost
                p.save(failOnError: true);
                return [
                    cost: totalCost,
                    state: 2, //success bought
                    count: count,
                    text: closures.msgSuccess.call()
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
            DecimalFormat df = new DecimalFormat("##.##")
            return  [
                state: 0, //error
                errorType: 0, //low balance
                count: totalCost-p.cash, //need balance
                text: "Недостаточно средств<br/>Не хватает ${df.format(totalCost-p.cash)} р."
            ] as JSON
        }
    }

    def purchaseBases(Map params, Person p) {
        params.closures = [:]
        params.closures.filterPersonBase = { Person person, Base base ->
            !PersonBase.exists(person.id, base.id)
        }
        params.closures.calcCost = { double cost ->
            cost
        }
        params.closures.processPersonBase = { Person person, Base base ->
            PersonBase.create(person, base)
        }
        params.closures.msgNothingToDo = {
            "Все выбранные базы уже куплены"
        }
        params.closures.msgSuccess = {
            "Базы успешно куплены"
        }
        process(params, p)
    }

    def upgradeBases(Map params, Person p) {
        params.closures = [:]
        params.closures.filterPersonBase = { Person u, Base b ->
            PersonBase.where {
                person == u && base == b && baseVersion < b.ver
            }.count() > 0
        }
        params.closures.calcCost = { double cost ->
            cost/2
        }
        params.closures.processPersonBase = { Person person, Base base ->
            PersonBase.remove(person, base, true)
            PersonBase.create(person, base, true)
        }
        params.closures.msgNothingToDo = {
            "Выбранные базы не требуют обновления"
        }
        params.closures.msgSuccess = {
            "Базы успешно обновлены"
        }
        process(params, p)
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
