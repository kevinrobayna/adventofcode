# frozen_string_literal: true

require_relative '../../lib/aoc'

def rows(input)
  input.lines.map { |l| l.split.map(&:to_i) }.reject(&:empty?)
end

def solve(input)
  rows(input).sum { |r| r.max - r.min }
end

def solve2(input)
  rows(input).sum do |r|
    r.permutation(2).find { |a, b| (a % b).zero? }.then { |a, b| a / b }
  end
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    5 1 9 5
    7 5 3
    2 4 6 8
  INPUT

  EXAMPLE2 = <<~INPUT
    5 9 2 8
    9 4 7 3
    3 8 6 5
  INPUT

  def test_solve_example
    assert_equal 18, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 50_376, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 9, solve2(EXAMPLE2)
  end

  def test_solve2_input
    assert_equal 267, solve2(read_file('input.txt'))
  end
end
