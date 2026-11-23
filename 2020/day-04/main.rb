# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

REQUIRED = %w[byr iyr eyr hgt hcl ecl pid].freeze

RULES = {
  'byr' => ->(v) { v.match?(/\A\d{4}\z/) && v.to_i.between?(1920, 2002) },
  'iyr' => ->(v) { v.match?(/\A\d{4}\z/) && v.to_i.between?(2010, 2020) },
  'eyr' => ->(v) { v.match?(/\A\d{4}\z/) && v.to_i.between?(2020, 2030) },
  'hgt' => lambda { |v|
    m = v.match(/\A(\d+)(cm|in)\z/)
    m && (m[2] == 'cm' ? m[1].to_i.between?(150, 193) : m[1].to_i.between?(59, 76))
  },
  'hcl' => ->(v) { v.match?(/\A#[0-9a-f]{6}\z/) },
  'ecl' => ->(v) { %w[amb blu brn gry grn hzl oth].include?(v) },
  'pid' => ->(v) { v.match?(/\A\d{9}\z/) }
}.freeze

def passports(input)
  input.split("\n\n").map { |block| block.split.to_h { |field| field.split(':', 2) } }
end

def solve(input)
  passports(input).count { |p| REQUIRED.all? { |k| p.key?(k) } }
end

def solve2(input)
  passports(input).count { |p| RULES.all? { |k, rule| p.key?(k) && rule.call(p[k]) } }
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
    byr:1937 iyr:2017 cid:147 hgt:183cm

    iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
    hcl:#cfa07d byr:1929

    hcl:#ae17e1 iyr:2013
    eyr:2024
    ecl:brn pid:760753108 byr:1931
    hgt:179cm

    hcl:#cfa07d eyr:2025 pid:166559648
    iyr:2011 ecl:brn hgt:59in
  INPUT

  INVALID = <<~INPUT
    eyr:1972 cid:100
    hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

    iyr:2019
    hcl:#602927 eyr:1967 hgt:170cm
    ecl:grn pid:012533040 byr:1946

    hcl:dab227 iyr:2012
    ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

    hgt:59cm ecl:zzz
    eyr:2038 hcl:74454a iyr:2023
    pid:3556412378 byr:2007
  INPUT

  VALID = <<~INPUT
    pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
    hcl:#623a2f

    eyr:2029 ecl:blu cid:129 byr:1989
    iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

    hcl:#888785
    hgt:164cm byr:2001 iyr:2015 cid:88
    pid:545766238 ecl:hzl
    eyr:2022

    iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
  INPUT

  def test_solve_example
    assert_equal 2, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 230, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 0, solve2(INVALID)
    assert_equal 4, solve2(VALID)
  end

  def test_solve2_input
    assert_equal 156, solve2(read_file('input.txt'))
  end
end
