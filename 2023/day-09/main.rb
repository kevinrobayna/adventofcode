# frozen_string_literal: true

require_relative '../../lib/aoc'

# For each history, the stack of difference rows down to all zeros.
def explore_history(input)
  input.each_line.map { |line| line.split.map(&:to_i) }.map do |current|
    values = [current]
    values << values.last.each_cons(2).map { |a, b| b - a } until values.last.all?(&:zero?)
    values
  end
end

def solve(input)
  explore_history(input).sum { |values| values.sum(&:last) }
end

def solve2(input)
  explore_history(input).sum do |values|
    values.reverse.reduce(0) { |result, row| row.first - result }
  end
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    0 3 6 9 12 15
    1 3 6 10 15 21
    10 13 16 21 30 45
  INPUT

  def test_solve_example
    assert_equal 114, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 2_005_352_194, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 5, solve2("10 13 16 21 30 45\n")
    assert_equal 2, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 1077, solve2(read_file('input.txt'))
  end
end
