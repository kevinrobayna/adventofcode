fun day9ProblemReader(string: String): List<Long> {
    return string
        .split("\n")
        .map { line -> line.toLong() }
        .toList()
}


// https://adventofcode.com/2020/day/9
class Day9(
    private val numbers: List<Long>,
    private val preamble: Int,
) {

    fun solvePart1(): Long {
        for (inx in preamble..numbers.size) {
            val previousFile = numbers.slice((inx - preamble)..inx)
            if (!calculateAllCombinations(previousFile).contains(numbers[inx])) {
                return numbers[inx]
            }
        }
        return 0
    }

    private fun calculateAllCombinations(subset: List<Long>): Set<Long> {
        val additions = mutableSetOf<Long>()
        for (n1 in subset) {
            for (n2 in subset) {
                if (n1 != n2) {
                    additions.add(n1.plus(n2))
                }
            }
        }
        return additions;
    }

    fun solvePart2(): Long {
        val numberToCheck = solvePart1()
        var numbersToAdd = mutableListOf<Long>()

        for (inx in 1..numbers.size) {
            inner@ for (x in inx..numbers.size) {
                numbersToAdd.add(numbers[x])
                val addition = numbersToAdd.sum()
                if (addition > numberToCheck) {
                    numbersToAdd = mutableListOf()
                    break@inner
                } else if (addition == numberToCheck) {
                    val sortedList : List<Long> = numbersToAdd.sorted()
                    return sortedList[0] + sortedList[sortedList.size - 1]
                }
            }
        }
        return 0
    }


}

fun main() {
    val problem = day9ProblemReader(Day9::class.java.getResource("day9.txt").readText())
    println("solution = ${Day9(problem, 25).solvePart1()}")
    println("solution = ${Day9(problem, 25).solvePart2()}")
}