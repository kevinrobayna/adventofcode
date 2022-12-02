data class TicketsWithRules(
    val rules: List<Pair<String, Pair<IntRange, IntRange>>>,
    val tickets: List<String>
)

fun day16ProblemReader(text: String): TicketsWithRules {
    val ruleRegex = "(\\w+):\\s(\\d+)-(\\d+)\\sor\\s(\\d+)-(\\d+)".toRegex()
    val rules: MutableList<Pair<String, Pair<IntRange, IntRange>>> = mutableListOf()
    val tickets: MutableList<String> = mutableListOf()
    text.split('\n').forEach { line ->
        if (line.matches(ruleRegex)) {
            val (key, o1, e1, o2, e2) = ruleRegex.matchEntire(line)!!.destructured
            rules.add(key to Pair(o1.toInt() .. e1.toInt(), o2.toInt() .. e2.toInt()))
        } else if (line.split(",").size > 1){
            tickets.add(line)
        }
    }
    return TicketsWithRules(rules, tickets)
}

// https://adventofcode.com/2020/day/16
class Day16(
    private val ticketsWithRules: TicketsWithRules,
) {

    fun solvePart1(): Long {
        return 0
    }

    fun solvePart2(): Long {
        return 0
    }
}

fun main() {
    val problem = day16ProblemReader(Day16::class.java.getResource("day16.txt").readText())
    println("solution = ${Day16(problem).solvePart1()}")
    println("solution part2 = ${Day16(problem).solvePart2()}")
}