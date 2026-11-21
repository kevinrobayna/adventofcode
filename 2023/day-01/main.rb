# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

NUMBERS_MAP = {
  one: 1,
  two: 2,
  three: 3,
  four: 4,
  five: 5,
  six: 6,
  seven: 7,
  eight: 8,
  nine: 9
}.freeze

def solve(input)
  input.each_line.sum do |line|
    numbers = line.chars.grep(/\d/)
    "#{numbers.first}#{numbers.last}".to_i
  end
end

def solve2(input)
  input.each_line.sum do |line|
    line = line.delete("\n")
    parsed_line = []
    head = 0
    (1..line.length).each do |tail|
      str_to_check = line[head...tail]
      NUMBERS_MAP.each do |key, value|
        if str_to_check.include?(key.to_s)
          parsed_line << value
          head = tail - 1
        elsif str_to_check.include?(value.to_s)
          parsed_line << value
          head = tail
        end
      end
    end
    "#{parsed_line.first}#{parsed_line.last}".to_i
  end
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet
  INPUT

  EXAMPLE2 = <<~INPUT
    two1nine
    eightwothree
    abcone2threexyz
    xtwone3four
    4nineeightseven2
    zoneight234
    7pqrstsixteen
  INPUT

  def test_solve_example
    assert_equal 142, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 54_951, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 142, solve2(EXAMPLE)
    assert_equal 281, solve2(EXAMPLE2)
  end

  def test_solve2_input
    assert_equal 55_218, solve2(read_file('input.txt'))
  end
end
