import java.lang.Math.floorMod

fun day13ProblemReader(text: String): Pair<Int, List<String>> {
    val lines = text.split('\n')
    return Pair(
        lines[0].toInt(),
        lines[1].split(",")
    )
}

// https://adventofcode.com/2020/day/13
class Day13(
    private val problem: Pair<Int, List<String>>,
) {

    fun solvePart1(): Int {
        val (target, schedule) = problem
        val ids = schedule.filter { it != "x" }
        val nextDeparture = ids.map {
            val id = it.toDouble()
            val lastDeparture = target % id
            ((target - lastDeparture) + id - target)
        }
        val minutesToNextBus = nextDeparture.minOrNull()

        return if (minutesToNextBus != null) {
            (minutesToNextBus.toInt() * ids[nextDeparture.indexOf(minutesToNextBus)].toInt())
        } else 0
    }

    // i do not fully understand this
    // source https://github.com/ephemient/aoc2020/blob/main/kt/src/main/kotlin/io/github/ephemient/aoc2020/Day13.kt
    fun solvePart2(): Long {
        val (_, schedule) = problem
        return schedule.withIndex()
            .filter { (_, id) -> id != "x" }
            .map { (inx, id) -> inx to id.toInt() }
            .map { (inx, id) -> floorMod(-inx, id).toLong() to id.toLong() }
            .fold(0L to 1L) { (r1, q1), (r2, q2) ->
                crt(r1, q1, r2, q2)
            }.first
    }

    private fun crt(r1: Long, q1: Long, r2: Long, q2: Long): Pair<Long, Long> {
        var a = r1
        var b = r2
        while (a != b) {
            if (a < b) {
                a += (b - a + q1 - 1) / q1 * q1
            } else {
                b += (a - b + q2 - 1) / q2 * q2
            }
        }
        return a to q1 * q2
    }
}

fun main() {
    val problem = day13ProblemReader(Day13::class.java.getResource("day13.txt").readText())
    println("solution = ${Day13(problem).solvePart1()}")
    println("solution part2 = ${Day13(problem).solvePart2()}")
}