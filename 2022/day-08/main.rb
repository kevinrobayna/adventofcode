# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def parse_input(input)
  input.split("\n").map { |line| line.chars.map(&:to_i) }
end

# Yields the four lines of sight (nearest tree first) from the tree at (row, col).
def lines_of_sight(grid, row, col)
  column = grid.map { |r| r[col] }
  [
    grid[row][0...col].reverse,
    grid[row][(col + 1)..],
    column[0...row].reverse,
    column[(row + 1)..]
  ]
end

def each_tree(grid)
  grid.each_index.flat_map do |row|
    grid[row].each_index.map { |col| yield(grid[row][col], lines_of_sight(grid, row, col)) }
  end
end

def solve(input)
  each_tree(parse_input(input)) do |height, sights|
    sights.any? { |trees| trees.all? { |t| t < height } }
  end.count(true)
end

def solve2(input)
  each_tree(parse_input(input)) do |height, sights|
    sights.map do |trees|
      blocker = trees.index { |t| t >= height }
      blocker ? blocker + 1 : trees.size
    end.reduce(:*)
  end.max
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    30373
    25512
    65332
    33549
    35390
  INPUT

  def test_solve_example
    assert_equal 21, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 1776, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 8, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 234_416, solve2(read_file('input.txt'))
  end
end
