// https://adventofcode.com/2020/day/4
class Day4(
    private val passports: List<Map<String, String>>,
) {
    fun solve(): Long {
        return passports.stream().filter { isValid(it) }.count()
    }

    private fun isValid(passport: Map<String, String>): Boolean {
        if (passport.size == 8 && arePassportFieldsValid(passport)) {
            return true // contains all required fields
        } else if (passport.size == 7 && !passport.containsKey("cid") && arePassportFieldsValid(passport)) {
            return true
        }
        return false
    }

    private fun arePassportFieldsValid(passport: Map<String, String>): Boolean {
        // byr (Birth Year) - four digits; at least 1920 and at most 2002.
        var byr : Int?
        try {
            byr = passport.get("byr")?.toInt()
        } catch (e: Exception) {
            return false
        }
        val validByr = byr != null && byr >= 1920 && byr <= 2002
        if (!validByr) {
            return false
        }

        // iyr (Issue Year) - four digits; at least 2010 and at most 2020.
        var iyr : Int?
        try {
            iyr = passport.get("iyr")?.toInt()
        } catch (e: Exception) {
            return false
        }
        val validIvr = iyr != null && iyr >= 2010 && iyr <= 2020
        if (!validIvr) {
            return false
        }

        // eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
        var eyr : Int?
        try {
            eyr = passport.get("eyr")?.toInt()
        } catch (e: Exception) {
            return false
        }
        val validEyr = eyr != null && eyr >= 2020 && eyr <= 2030
        if (!validEyr) {
            return false
        }

        // hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
        val hcl = passport.get("hcl")
        val validHcl = hcl != null && hcl.startsWith("#") && hcl.length == 7
        if (!validHcl) {
            return false
        }

        // ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
        val ecl = passport.get("ecl")
        val validEcl = ecl != null && ecl in listOf("amb", "blu", "brn", "gry", "grn", "hzl", "oth")
        if (!validEcl) {
            return false
        }

        // pid (Passport ID) - a nine-digit number, including leading zeroes.
        val pid = passport.get("pid")
        var pidNumber : Int?
        try {
            pidNumber = pid?.toInt()
        } catch (e: Exception) {
            return false
        }

        val validPid = pid != null && pidNumber != null && pid.length == 9 && pidNumber > 0
        if (!validPid) {
            return false
        }


        // hgt (Height) - a number followed by either cm or in:
        //              If cm, the number must be at least 150 and at most 193.
        //              If in, the number must be at least 59 and at most 76.
        val hgt = passport.get("hgt")
        val validHgt = hgt != null && isValidHeight(hgt)
        if (!validHgt) {
            return false
        }
        return true
    }

    private fun isValidHeight(height: String): Boolean {
        val value = height.dropLast(2)
        var valueInt : Int?
        try {
            valueInt = value.toInt()
        } catch (e: Exception) {
            return false
        }
        val system = height.drop(value.length)
        if (system == "cm" && valueInt >= 150 && valueInt <= 193) {
            return true
        } else if (system == "in" && valueInt >= 59 && valueInt <= 76) {
            return true
        }
        return false
    }
}


fun main() {
    val problem = day4ProblemReader(Day4::class.java.getResource("day4.txt").readText())
    println("solution = ${Day4(problem).solve()}")
}

fun day4ProblemReader(str: String): List<Map<String, String>> {
    val problemSplit = str.split("\n")
    val problem = mutableListOf<Map<String, String>>()
    var passport = mutableMapOf<String, String>()
    for (lineCount in problemSplit.indices) {
        val line = problemSplit[lineCount]
        if (line.isNotBlank()) {
            line.split(" ").forEach {
                val passportElement = it.split(":")
                passport[passportElement[0]] = passportElement[1]
            }
        }

        val isLastLine = lineCount == (problemSplit.size - 1)
        if (line.isBlank() || isLastLine) {
            problem.add(passport)
            passport = mutableMapOf()
            continue
        }
    }
    return problem
}