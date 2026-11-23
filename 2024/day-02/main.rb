# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def parse(input)
  input.lines.map { _1.split.map(&:to_i) }
end

def safe?(levels)
  diffs = levels.each_cons(2).map { |a, b| b - a }
  diffs.all? { (1..3).cover?(_1) } || diffs.all? { (-3..-1).cover?(_1) }
end

def solve(input)
  parse(input).count { safe?(_1) }
end

def solve2(input)
  parse(input).count do |levels|
    safe?(levels) || levels.each_index.any? { |i| safe?(levels.reject.with_index { |_, j| j == i }) }
  end
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9
  INPUT

  def test_safe
    assert safe?([7, 6, 4, 2, 1])
    assert safe?([1, 3, 6, 7, 9])
    refute safe?([1, 2, 7, 8, 9])
    refute safe?([9, 7, 6, 2, 1])
    refute safe?([1, 3, 2, 4, 5])
    refute safe?([8, 6, 4, 4, 1])
  end

  def test_solve_example
    assert_equal 2, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 631, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 4, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 665, solve2(read_file('input.txt'))
  end
end
