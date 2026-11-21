# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def joltages(input)
  adapters = input.split.map(&:to_i).sort
  [0, *adapters, adapters.last + 3]
end

def solve(input)
  diffs = joltages(input).each_cons(2).map { |a, b| b - a }.tally
  diffs[1] * diffs[3]
end

def solve2(input)
  ways = Hash.new(0)
  ways[0] = 1
  joltages(input).drop(1).each { |j| ways[j] = ways[j - 1] + ways[j - 2] + ways[j - 3] }
  ways.values.last
end

class AoCTest < Minitest::Test
  SMALL = <<~INPUT
    16
    10
    15
    5
    1
    11
    7
    19
    6
    12
    4
  INPUT

  EXAMPLE = <<~INPUT
    28
    33
    18
    42
    31
    14
    46
    20
    48
    47
    24
    23
    49
    45
    19
    38
    39
    11
    1
    32
    25
    35
    8
    17
    7
    9
    4
    2
    34
    10
    3
  INPUT

  def test_solve_example
    assert_equal 35, solve(SMALL)
    assert_equal 220, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 2400, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 8, solve2(SMALL)
    assert_equal 19_208, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 338_510_590_509_056, solve2(read_file('input.txt'))
  end
end
