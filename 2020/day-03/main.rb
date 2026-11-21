# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def trees(grid, right, down)
  (0...grid.size).step(down).each_with_index.count do |row, i|
    grid[row][(i * right) % grid[row].size] == '#'
  end
end

def solve(input)
  trees(input.split, 3, 1)
end

def solve2(input)
  grid = input.split
  [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]].map { |r, d| trees(grid, r, d) }.reduce(:*)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    ..##.......
    #...#...#..
    .#....#..#.
    ..#.#...#.#
    .#...##..#.
    ..#.##.....
    .#.#.#....#
    .#........#
    #.##...#...
    #...##....#
    .#..#...#.#
  INPUT

  def test_solve_example
    assert_equal 7, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 274, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 336, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 6_050_183_040, solve2(read_file('input.txt'))
  end
end
