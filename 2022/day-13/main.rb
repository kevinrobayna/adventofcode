# frozen_string_literal: true

require_relative '../../lib/aoc'
require 'json'

def parse_input(input)
  input.split("\n").reject(&:empty?).map { |line| JSON.parse(line) }
end

# Returns -1 when left comes before right, 1 when after, 0 when undecided.
def compare(left, right)
  case [left, right]
  in [Integer, Integer] then left <=> right
  in [Array, Array]
    left.zip(right).each do |l, r|
      return 1 if r.nil?

      result = compare(l, r)
      return result unless result.zero?
    end
    left.size <=> right.size
  in [Integer, Array] then compare([left], right)
  in [Array, Integer] then compare(left, [right])
  end
end

def solve(input)
  parse_input(input).each_slice(2).with_index(1).sum do |(left, right), inx|
    compare(left, right).negative? ? inx : 0
  end
end

def solve2(input)
  dividers = [[[2]], [[6]]]
  sorted = (parse_input(input) + dividers).sort { |a, b| compare(a, b) }
  dividers.map { |d| sorted.index(d) + 1 }.reduce(:*)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    [1,1,3,1,1]
    [1,1,5,1,1]

    [[1],[2,3,4]]
    [[1],4]

    [9]
    [[8,7,6]]

    [[4,4],4,4]
    [[4,4],4,4,4]

    [7,7,7,7]
    [7,7,7]

    []
    [3]

    [[[]]]
    [[]]

    [1,[2,[3,[4,[5,6,7]]]],8,9]
    [1,[2,[3,[4,[5,6,0]]]],8,9]
  INPUT

  def test_solve_example
    assert_equal 13, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 5808, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 140, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 22_713, solve2(read_file('input.txt'))
  end
end
