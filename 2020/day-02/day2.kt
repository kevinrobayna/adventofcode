import java.util.stream.Collectors

data class PolicyAndPassword(
    val min: Int,
    val max: Int,
    val str: String,
    val password: String,
)

// https://adventofcode.com/2020/day/2
class Day2(
    private val values: List<PolicyAndPassword>
) {
    fun solve(): Long {
        return values
            .stream()
            .filter { policyAndPassword ->
                policyAndPassword
                    .password.split("")
                    .stream()
                    .filter { requiredString ->
                        requiredString == policyAndPassword.str
                    }
                    .count() in policyAndPassword.min..policyAndPassword.max
            }.count()
    }
}

// https://adventofcode.com/2020/day/2
class Day2Part2(
    private val values: List<PolicyAndPassword>
) {
    fun solve(): Long {
        return values
            .stream()
            .filter { checkPolicyPart2(it) }
            .count()
    }

    private fun checkPolicyPart2(it: PolicyAndPassword): Boolean {
        val part1 = it.password[it.min - 1].toString() == it.str
        val part2 = it.password[it.max - 1].toString() == it.str
        if (part1 && part2) {
            return false
        } else if (part1 || part2) {
            return true
        }
        return false
    }
}

/**
 * example of line 1-7 j: vrfjljjwbsv
 */
fun lineToPolicyAndPassword(line: String): PolicyAndPassword {
    val policyAndPassword = line.split(':')
    val rangeAndChar = policyAndPassword[0].split(' ')
    val range = rangeAndChar[0].split('-')
    return PolicyAndPassword(
        range[0].toInt(), // min
        range[1].toInt(), // max
        rangeAndChar[1].trim(), // str to check
        policyAndPassword[1].trim() // password
    )
}

fun main() {
    val problem = Day2::class.java.getResource("day2.txt")
        .readText()
        .split('\n')
        .stream()
        .map { lineToPolicyAndPassword(it) }
        .collect(Collectors.toList())
    val solution = Day2(problem).solve()
    println("solution = $solution")

    val solutionPart2 = Day2Part2(problem).solve()
    println("solutionPart2 = $solutionPart2")
}