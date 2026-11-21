# frozen_string_literal: true

require_relative '../../lib/aoc'

MOVES = { '^' => [0, -1], 'v' => [0, 1], '>' => [1, 0], '<' => [-1, 0] }.freeze

def visit(directions)
  x = y = 0
  directions.each_with_object(Set[[0, 0]]) do |char, seen|
    dx, dy = MOVES.fetch(char)
    x += dx
    y += dy
    seen << [x, y]
  end
end

def solve(input)
  visit(input.strip.chars).size
end

def solve2(input)
  santa, robot = input.strip.chars.partition.with_index { |_, i| i.even? }
  (visit(santa) | visit(robot)).size
end

class AoCTest < Minitest::Test
  def test_solve_example
    assert_equal 2, solve('>')
    assert_equal 4, solve('^>v<')
    assert_equal 2, solve('^v^v^v^v^v')
  end

  def test_solve_input
    assert_equal 2572, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 3, solve2('^v')
    assert_equal 3, solve2('^>v<')
    assert_equal 11, solve2('^v^v^v^v^v')
  end

  def test_solve2_input
    assert_equal 2631, solve2(read_file('input.txt'))
  end
end
