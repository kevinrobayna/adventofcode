import java.util.stream.Collectors
import kotlin.math.roundToLong

data class BoardingPass(
    val row: List<String>,
    val seat: List<String>
) {
    companion object {
        const val LEFT = "L"
        const val RIGHT = "R"
        const val BACK = "B"
        const val FRONT = "F"
    }
}

fun day5ProblemReader(string: String): List<BoardingPass> {
    return string.split("\n").stream().map { line ->
        val row = mutableListOf<String>()
        val seat = mutableListOf<String>()
        line.split("").forEach {
            if (it == BoardingPass.LEFT || it == BoardingPass.RIGHT) {
                seat.add(it)
            } else if (it == BoardingPass.BACK || it == BoardingPass.FRONT) {
                row.add(it)
            }
        }
        BoardingPass(row, seat)
    }.collect(Collectors.toList())
}


// https://adventofcode.com/2020/day/5
class Day5(
    private val boardingPasses: List<BoardingPass>,
) {

    companion object {
        const val ROW_RANGE: Long = 128
        const val COLUMN_RANGE: Long = 8
    }

    private fun calculateIds(): List<Long> {
        return boardingPasses
            .stream()
            .map { calculateSeatId(it) }
            .sorted()
            .collect(Collectors.toList())
    }

    fun getHighestSeatId(): Long {
        return calculateIds()[boardingPasses.size - 1]
    }

    fun getMySeat(): Long {
        val ids = calculateIds()
        var index = ids.size - 1
        while ((ids[index] - ids[index - 1]) == 1L) {
            index -= 1
        }
        return ids[index] - 1
    }

    private fun calculateSeatId(boardingPass: BoardingPass): Long {
        return (calculateRowNumber(boardingPass) * COLUMN_RANGE) + calculateColumnNumber(boardingPass)
    }

    private fun calculateRowNumber(boardingPass: BoardingPass): Long {
        if (boardingPass.row.isEmpty()) {
            return 1
        }
        return calculateNumber(boardingPass.row, ROW_RANGE, BoardingPass.BACK)
    }

    private fun calculateColumnNumber(boardingPass: BoardingPass): Long {
        if (boardingPass.seat.isEmpty()) {
            return 1
        }
        return calculateNumber(boardingPass.seat, COLUMN_RANGE, BoardingPass.RIGHT)
    }

    private fun calculateNumber(list: List<String>, endRange: Long, upHalfChar: String): Long {
        var startPost: Long = 0
        var endPosition: Long = endRange.minus(1)
        for (character in list) {
            if (endPosition - startPost == 1L) {
                if (character == upHalfChar) {
                    return endPosition
                }
                return startPost
            }
            if (character == upHalfChar) {
                startPost = (((endPosition - startPost) / 2.0) + startPost).roundToLong()
            } else {
                endPosition = ((endPosition - startPost) / 2) + startPost
            }
        }
        return startPost
    }
}


fun main() {
    val problem = day5ProblemReader(Day4::class.java.getResource("day5.txt").readText())
    println("solution = ${Day5(problem).getHighestSeatId()}")
    println("solution = ${Day5(problem).getMySeat()}")
}