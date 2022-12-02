fun day17ProblemReader(text: String): List<String> {
    return text.split(',')
}

// https://adventofcode.com/2020/day/17
class Day17(
    private val initialState: List<String>,
) {

    fun solvePart1(): Long {
        return 0
    }

    fun solvePart2(): Long {
        return 0
    }
}

fun main() {
    val problem = day17ProblemReader(Day17::class.java.getResource("day17.txt").readText())
    println("solution = ${Day17(problem).solvePart1()}")
    println("solution part2 = ${Day17(problem).solvePart2()}")
}