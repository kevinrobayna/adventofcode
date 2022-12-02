import java.util.*

fun day10ProblemReader(string: String): List<Int> {
    return string
        .split("\n")
        .map { line -> line.toInt() }
        .toList()
}


// https://adventofcode.com/2020/day/10
class Day10(
    private val numbers: List<Int>
) {

    fun solvePart1(): Int {
        var n1 = 0
        var n3 = 0
        numbers.sorted().fold(0) { a, b ->
            when (b - a) {
                1 -> n1++
                3 -> n3++
            }
            b
        }
        return n1 * (n3 + 1)
    }

    // This does not work on big set
    fun solvePart2_naive(): Long {
        val max = numbers.maxOrNull()!!.plus(3)
        var solutions = 0L
        val solutionsToExplore: Queue<List<Int>> = LinkedList()
        solutionsToExplore.add(listOf(0))
        do {
            val solution = solutionsToExplore.remove()
            val maxVal = solution.maxOrNull()
            if (maxVal != null) {
                if (max == maxVal.plus(3)) {
                    solutions += 1L
                }
                for (x in 1..3) {
                    if (numbers.contains(maxVal.plus(x))) {
                        val newSolution = solution.toMutableList()
                        newSolution.add(maxVal.plus(x))
                        solutionsToExplore.add(newSolution)
                    }
                }
            }
        } while (solutionsToExplore.isNotEmpty())
        return solutions
    }

    fun solvePart2(): Long {
        val k = longArrayOf(1, 0, 0, 0)
        numbers.sorted().fold(0) { a, b ->
            val d = b - a
            k.copyInto(k, d, 0, k.size - d)
            k.fill(0, 0, d)
            k[0] += k.sum()
            b
        }
        return k[0]
    }


}

fun main() {
    val problem = day10ProblemReader(Day10::class.java.getResource("day10.txt").readText())
    println("solution = ${Day10(problem).solvePart1()}")
    println("solution part2 = ${Day10(problem).solvePart2()}")
}