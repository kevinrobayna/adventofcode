import java.io.File
import java.util.stream.Collectors


fun readFile(fileName: String): String = File(fileName).readText(Charsets.UTF_8)

fun parseProblem(content: String): List<Int> {
    content.split("\n").stream().map { it.toInt() }.collect(Collectors.toList())
}

fun solve(content: String): Int {
    val values = parseProblem(content)
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

fun solve2(content: String): Int {
    val values = parseProblem(content)
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


val test = readFile("test.txt")
val real = readFile("input.txt")

println("Part1 Test ${solve(test)}")
println("Part1 ${solve(real)}")
println("Part2 Test ${solve2(test)}")
println("Part2 ${solve2(real)}")