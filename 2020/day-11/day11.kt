import java.util.stream.Collectors

fun day11ProblemReader(text: String): List<List<String>> = text
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

// https://adventofcode.com/2020/day/11
class Day11(
    private val seats: List<List<String>>,
    private val threshold: Int,
    private val lookFar: Boolean = false
) {
    companion object {
        const val FREE = "L"
        const val FLOOR = "."
        const val OCCUPIED = "#"
        val neighbours = listOf(
            Pair(-1, -1),
            Pair(-1, 0),
            Pair(-1, 1),
            Pair(1, -1),
            Pair(1, 0),
            Pair(1, 1),
            Pair(0, -1),
            Pair(0, 1),
        )
    }

    fun solve(): Int {
        var changes: Int
        var originalSeats: MutableList<MutableList<String>> = seats.map { it.toMutableList() }.toMutableList()
        var seatsToChange: MutableList<MutableList<String>>
        do {
            changes = 0
            seatsToChange = originalSeats.map { it.toMutableList() }.toMutableList()
            for (row in seats.indices) {
                for (column in seats[row].indices) {
                    if (originalSeats[row][column] == FLOOR) {
                        continue
                    }
                    val adjacentSeats = exploreNeighbours(originalSeats, row, column)
                    // rule n1
                    val emptySeats = adjacentSeats.filter { it in listOf(FLOOR, FREE) }.size
                    if (originalSeats[row][column] == FREE && emptySeats == neighbours.size) {
                        seatsToChange[row][column] = OCCUPIED
                        changes += 1
                    }

                    // rule n2
                    val usedSeats = adjacentSeats.filter { it in listOf(OCCUPIED) }.size
                    if (originalSeats[row][column] == OCCUPIED && usedSeats >= threshold) {
                        seatsToChange[row][column] = FREE
                        changes += 1
                    }
                }
            }
            originalSeats = seatsToChange.map { it.toMutableList() }.toMutableList()
        } while (changes != 0)
        return originalSeats.map { line -> line.filter { it == OCCUPIED }.count() }.sum()
    }

    private fun exploreNeighbours(map: List<List<String>>, x: Int, y: Int): List<String> {
        return neighbours.map { (i, j) ->
            findSeat(map, Pair(x, y), Pair(i, j))
        }
    }

    private fun findSeat(map: List<List<String>>, current: Pair<Int, Int>, next: Pair<Int, Int>): String {
        val (x, y) = current
        val (i, j) = next
        val seat = listOf(FREE, OCCUPIED)
        return if (x + i < 0 || y + j < 0) FLOOR
        else if (x + i > map.size - 1 || y + j > map[0].size - 1) FLOOR
        else {
            if (!lookFar) map[x + i][y + j]
            else if (map[x + i][y + j] in seat) map[x + i][y + j]
            else findSeat(map, Pair(x + i, y + j), Pair(i, j))
        }
    }

}

fun main() {
    val problem = day11ProblemReader(Day10::class.java.getResource("day11.txt").readText())
    println("solution = ${Day11(problem, 4).solve()}")
    println("solution part2 = ${Day11(problem, 5, true).solve()}")
}