fun day19ProblemReader(text: String): List<String> {
    return text.split(',')
}

// https://adventofcode.com/2020/day/19
class Day19(
    private val receivedMessage: List<String>,
) {

    fun solvePart1(): Long {
        return 0
    }

    fun solvePart2(): Long {
        return 0
    }
}

fun main() {
    val problem = day19ProblemReader(Day19::class.java.getResource("day19.txt").readText())
    println("solution = ${Day19(problem).solvePart1()}")
    println("solution part2 = ${Day19(problem).solvePart2()}")
}