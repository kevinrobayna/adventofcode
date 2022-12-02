import java.util.stream.Collectors

fun day6ProblemReader(string: String): List<List<Set<String>>> {
    val problemSplit = string.split("\n")
    val problem = mutableListOf<List<Set<String>>>()
    var group = mutableListOf<Set<String>>()
    for (lineCount in problemSplit.indices) {
        val line = problemSplit[lineCount]
        if (line.isNotBlank()) {
            val individualVotes = mutableSetOf<String>()
            line.split("").forEach {
                if (it.isNotBlank()) {
                    individualVotes.add(it)
                }
            }
            group.add(individualVotes)
        }

        val isLastLine = lineCount == (problemSplit.size - 1)
        if (line.isBlank() || isLastLine) {
            problem.add(group)
            group = mutableListOf()
            continue
        }
    }
    return problem
}


// https://adventofcode.com/2020/day/6
class Day6(
    private val quiz: List<List<Set<String>>>,
) {

    fun solveAnyone(): Long {
        return quiz
            .stream()
            .map { personResponses ->
                val responses = mutableSetOf<String>()
                personResponses.forEach {
                    responses.addAll(it)
                }
                responses
            }.map { it.size.toLong() }
            .collect(Collectors.toList())
            .sum()
    }

    fun solveEveryone(): Long {
        return quiz
            .stream()
            .map { personResponses: List<Set<String>> ->
                val firstPerson = personResponses.first()
                firstPerson
                    .stream()
                    .filter { response ->
                        personResponses.stream().filter { it.contains(response) }
                            .count() == personResponses.size.toLong()
                    }
                    .map {
                        it.length.toLong()
                    }
                    .collect(Collectors.toList())
            }
            .map {
                it.size.toLong()
            }
            .collect(Collectors.toList()).sum()
    }

}

fun main() {
    val problem = day6ProblemReader(Day6::class.java.getResource("day6.txt").readText())
    println("solution anyone = ${Day6(problem).solveAnyone()}")
    println("solution everyone = ${Day6(problem).solveEveryone()}")
}