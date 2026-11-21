# frozen_string_literal: true

require_relative '../../lib/aoc'

def count_overlaps(input, diagonals:)
  counts = Hash.new(0)
  input.scan(/(\d+),(\d+) -> (\d+),(\d+)/).each do |coords|
    x1, y1, x2, y2 = coords.map(&:to_i)
    next if !diagonals && x1 != x2 && y1 != y2

    dx = x2 <=> x1
    dy = y2 <=> y1
    steps = [(x2 - x1).abs, (y2 - y1).abs].max
    (0..steps).each { |i| counts[[x1 + (i * dx), y1 + (i * dy)]] += 1 }
  end
  counts.count { |_, v| v >= 2 }
end

def solve(input)
  count_overlaps(input, diagonals: false)
end

def solve2(input)
  count_overlaps(input, diagonals: true)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    0,9 -> 5,9
    8,0 -> 0,8
    9,4 -> 3,4
    2,2 -> 2,1
    7,0 -> 7,4
    6,4 -> 2,0
    0,9 -> 2,9
    3,4 -> 1,4
    0,0 -> 8,8
    5,5 -> 8,2
  INPUT

  def test_solve_example
    assert_equal 5, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 5124, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 12, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 19_771, solve2(read_file('input.txt'))
  end
end
