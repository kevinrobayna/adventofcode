import java.util.stream.Collectors

// https://adventofcode.com/2020/day/3
class Day3(
    private val forest: List<List<String>>,
    private val down: Int,
    private val right: Int,
) {
    companion object {
        const val TREE = "#"
    }

    fun solve(): Long {
        var position = Pair(0, 0)
        var treeCount: Long = 0
        for (levels in forest.indices) {
            if (isTree(position.first, position.second)) {
                treeCount++
            }
            position = next(position.first, position.second)
            if (position.first > forest.size) {
                return treeCount
            }
        }
        return treeCount
    }

    fun next(x: Int, y: Int): Pair<Int, Int> {
        return Pair(x.plus(down), y.plus(right) % forest[0].size)
    }

    fun isTree(x: Int, y: Int): Boolean {
        return forest[x][y] == TREE
    }
}

class Part2Day3(
    private val forest: List<List<String>>,
    private val routes: List<Pair<Int, Int>>,
) {
    fun solve(): Long {
        var solution: Long = 1
        val solutions = routes.stream().map {
            val s = Day3(forest, it.first, it.second).solve()
            println("solution with route $it = $s")
            s
        }.collect(Collectors.toList())
        for (x: Long in solutions) {
            solution = solution.times(x)
        }

        return solution
    }
}

fun main() {
    val problem: List<List<String>> = buildMapFromString(Day3::class.java.getResource("day3.txt").readText())
    println("solution = ${Day3(problem, 1, 3).solve()}")

    val routes = listOf(
        Pair(1, 1),
        Pair(1, 3),
        Pair(1, 5),
        Pair(1, 7),
        Pair(2, 1),
    )
    println("solution_Part = ${Part2Day3(problem, routes).solve()}")
}

fun buildMapFromString(text: String): List<List<String>> = text
    .split('\n')
    .stream()
    .map { line ->
        line.trim()
            .split("")
            .stream()
            .filter { it != "" }
            .collect(Collectors.toList())
    }
    .collect(Collectors.toList())