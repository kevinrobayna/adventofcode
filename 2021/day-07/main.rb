# frozen_string_literal: true

require_relative '../../lib/aoc'

def min_fuel(input)
  crabs = input.scan(/\d+/).map(&:to_i)
  crabs.min.upto(crabs.max).map { |target| crabs.sum { |c| yield((c - target).abs) } }.min
end

def solve(input)
  min_fuel(input) { |distance| distance }
end

def solve2(input)
  min_fuel(input) { |distance| distance * (distance + 1) / 2 }
end

class AoCTest < Minitest::Test
  EXAMPLE = "16,1,2,0,4,2,7,1,2,14\n"

  def test_solve_example
    assert_equal 37, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 355_764, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 168, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 99_634_572, solve2(read_file('input.txt'))
  end
end
