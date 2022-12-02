import kotlin.math.abs

fun day12ProblemReader(text: String): List<Pair<String, Int>> {
    return text
        .split('\n')
        .map { line ->
            Pair(line.trim().filter { !it.isDigit() }, line.trim().filter { it.isDigit() }.toInt())
        }
}

// https://adventofcode.com/2020/day/12
class Day12(
    private val actions: List<Pair<String, Int>>,
) {
    companion object {
        const val NORTH = "N"
        const val SOUTH = "S"
        const val EAST = "E"
        const val WEST = "W"
        const val FORWARD = "F"
        val MOVEMENTS = listOf(NORTH, SOUTH, EAST, WEST, FORWARD)

        const val LEFT = "L"
        const val RIGHT = "R"
    }

    fun solvePart1(): Int {
        return solve(Pair(1, 0), false)
    }

    fun solvePart2(): Int {
        return solve(Pair(10, 1), true)
    }

    private fun solve(direction: Pair<Int, Int> = Pair(1, 0), waypoint: Boolean = false): Int {
        var (dx, dy) = direction
        var (x, y) = Pair(0, 0)
        for ((change, amount) in actions) {
            when (change in MOVEMENTS) {
                true -> {
                    when (change) {
                        NORTH -> {
                            if (waypoint) dy += amount
                            else y += amount
                        }
                        SOUTH -> {
                            if (waypoint) dy -= amount
                            else y -= amount
                        }
                        EAST -> {
                            if (waypoint) dx += amount
                            else x += amount
                        }
                        WEST -> {
                            if (waypoint) dx -= amount
                            else x -= amount
                        }
                        FORWARD -> {
                            x += dx * amount
                            y += dy * amount
                        }
                    }
                }
                else -> {
                    when (amount) {
                        90 -> when (change) {
                            LEFT -> dx = -dy.also { dy = dx }
                            RIGHT -> dy = -dx.also { dx = dy }
                        }
                        180 -> dx = -dx.also { dy = -dy }
                        270 -> when (change) {
                            LEFT -> dy = -dx.also { dx = dy }
                            RIGHT -> dx = -dy.also { dy = dx }
                        }
                    }
                }
            }
        }
        return abs(x) + abs(y)
    }
}

fun main() {
    val problem = day12ProblemReader(Day10::class.java.getResource("day12.txt").readText())
    println("solution = ${Day12(problem).solvePart1()}")
    println("solution part2 = ${Day12(problem).solvePart2()}")
}