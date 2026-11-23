# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def parse(input)
  input.lines.map do |line|
    target, nums = line.split(':')
    [target.to_i, nums.split.map(&:to_i)]
  end
end

# Works backwards from the target, undoing the last operator, which prunes heavily.
def solvable?(target, nums, concat)
  *rest, last = nums
  return target == last if rest.empty?

  return true if target > last && solvable?(target - last, rest, concat)
  return true if (target % last).zero? && solvable?(target / last, rest, concat)
  return false unless concat

  suffix = last.to_s
  str = target.to_s
  str.size > suffix.size && str.end_with?(suffix) && solvable?(str[0...-suffix.size].to_i, rest, concat)
end

def calibration(input, concat:)
  parse(input).select { |target, nums| solvable?(target, nums, concat) }.sum(&:first)
end

def solve(input)
  calibration(input, concat: false)
end

def solve2(input)
  calibration(input, concat: true)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    190: 10 19
    3267: 81 40 27
    83: 17 5
    156: 15 6
    7290: 6 8 6 15
    161011: 16 10 13
    192: 17 8 14
    21037: 9 7 18 13
    292: 11 6 16 20
  INPUT

  def test_solve_example
    assert_equal 3749, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 5_512_534_574_980, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 11_387, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 328_790_210_468_594, solve2(read_file('input.txt'))
  end
end
