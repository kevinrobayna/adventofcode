fun day18ProblemReader(text: String): List<String> {
    return text.split("\n")
}

// https://adventofcode.com/2020/day/18
class Day18(
    private val operations: List<String>,
) {

    fun solvePart1(): Long {
        return operations
            .asSequence()
            .map { "(%s)".format(it) }
            .map { it.replace(" ", "") }
            .map { resolveOperation(it, 0) }
            .map { (result, _) -> result }
            .sum()
    }

    private fun resolveOperation(line: String, start: Int): Pair<Long, Int> {
        var result = 0L
        var inx = start
        var operand1String = ""
        var operation = ""
        var operand2String = ""
        while (inx < line.length) {
            val valueX = line[inx].toString()
            if (valueX == "(") {
                if (operand1String.isEmpty()) {
                    val (r, x) = resolveOperation(line, inx + 1)
                    result = r
                    operand1String = r.toString()
                    inx = x
                } else if (operand2String.isEmpty()) {
                    val (r, x) = resolveOperation(line, inx + 1)
                    operand2String = r.toString()
                    inx = x
                }
            } else if (valueX == ")") {
                return eval(operation, operand1String, operand2String) to inx
            } else if (line[inx].isDigit() && operation.isEmpty()) {
                operand1String = "%s%s".format(operand1String, line[inx])
            } else if (line[inx].isDigit() && operation.isNotEmpty()) {
                operand2String = "%s%s".format(operand2String, line[inx])
            } else if (!line[inx].isDigit() && operand1String.isNotEmpty() && operation.isEmpty()) {
                operation = line[inx].toString()
            } else if (!line[inx].isDigit() && operand2String.isNotEmpty()) {
                result = eval(operation, operand1String, operand2String)
                operand1String = result.toString()
                operation = line[inx].toString()
                operand2String = ""
            }
            inx += 1
        }
        return result to inx
    }

    private fun eval(
        operation: String,
        operand1String: String,
        operand2String: String
    ): Long {
        return when (operation) {
            "+" -> {
                operand1String.toLong().plus(operand2String.toLong())
            }
            "*" -> {
                operand1String.toLong().times(operand2String.toLong())
            }
            else -> {
                0
            }
        }
    }

    fun solvePart2(): Long {
        return 0
    }
}

fun main() {
    val problem = day18ProblemReader(Day18::class.java.getResource("day18.txt").readText())
    println("solution = ${Day18(problem).solvePart1()}")
    println("solution part2 = ${Day18(problem).solvePart2()}")
}