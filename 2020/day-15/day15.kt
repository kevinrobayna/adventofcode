fun day15ProblemReader(text: String): List<String> {
    return text.split(',')
}

// https://adventofcode.com/2020/day/15
class Day15(
    private val spokenNumbers: List<String>,
) {

    fun solvePart1(): Int {
        return playRoundsUntil(2020)
    }

    fun solvePart2(): Int {
        return playRoundsUntil(30000000)
    }

    private fun playRoundsUntil(lastTurn: Int): Int {
        val numbers = spokenNumbers.map { it.toInt() }
        var lastNumber = numbers.last()
        // because some dark magic this with a map is terribly slow
        val spokenBefore = IntArray(maxOf(lastTurn, numbers.maxOf { it + 1 }))
        for ((turn, number) in spokenNumbers.subList(0, spokenNumbers.lastIndex).withIndex()) {
            spokenBefore[number.toInt()] = turn + 1
        }
        for (turn in numbers.size until lastTurn) {
            val lastTurnSpoken = spokenBefore[lastNumber]
            spokenBefore[lastNumber] = turn
            lastNumber = if (lastTurnSpoken == 0) 0 else turn - lastTurnSpoken
        }
        return lastNumber
    }
}

fun main() {
    val problem = day15ProblemReader("2,0,1,9,5,19")
    println("solution = ${Day15(problem).solvePart1()}")
    println("solution part2 = ${Day15(problem).solvePart2()}")
}