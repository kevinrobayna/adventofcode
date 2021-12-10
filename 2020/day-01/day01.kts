import java.util.stream.Collectors
import java.io.File
import kotlin.String


fun readFile(filename: String): List<String> {
    return File(filename).useLines { it.toList() }
}

class Day1(
        private val content: List<String>
) {
    fun solve(): Int {
        val values = parseProblem()
        val pairs: MutableList<Pair<Int, Int>> = mutableListOf()

        for (outLoop in values.indices) {
            for (innerLoop in values.indices) {
                if (!outLoop.equals(innerLoop)) {
                    val first = Math.max(values[outLoop], values[innerLoop])
                    val second = Math.min(values[outLoop], values[innerLoop])
                    pairs.add(Pair(first, second))
                }
            }
        }

        val pair = pairs
                .filter { it.first + it.second == 2020 }
                .distinct()
                .get(0)

        return pair.first * pair.second
    }

    fun solve2(): Int {
        val values = parseProblem()
        val tuples: MutableList<Triple<Int, Int, Int>> = mutableListOf()

        for (outLoop in values) {
            for (innerLoop in values) {
                for (innerInnerLoop in values) {
                    val points = listOf(outLoop, innerLoop, innerInnerLoop).sorted()
                    tuples.add(Triple(points[0], points[1], points[2]))
                }
            }
        }

        val triple = tuples
                .filter { it.first.plus(it.second).plus(it.third) == 2020 }
                .distinct()
                .get(0)

        return triple.first * triple.second * triple.third
    }

    private fun parseProblem(): List<Int> {
        return this.content.stream().map { it.toInt() }.collect(Collectors.toList())
    }
}


val test = readFile("test.txt")
val real = readFile("input.txt")


println("Part1 Test ${Day1(test).solve()}")
println("Part1 ${Day1(real).solve()}")
println("Part2 Test ${Day1(test).solve2()}")
println("Part2 ${Day1(real).solve2()}")