# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def solve(input, expansion: 2)
  grid = input.lines.map { it.strip.chars }
  positions = []
  grid.each_with_index do |row, x|
    row.each_with_index { |v, y| positions << [x, y] if v == '#' }
  end
  empty_rows = grid.each_index.reject { |x| grid[x].include?('#') }
  empty_columns = grid.first.each_index.reject { |y| grid.any? { it[y] == '#' } }

  positions.combination(2).sum do |p1, p2|
    distance(p1, p2, empty_rows, empty_columns, expansion)
  end
end

def solve2(input, expansion: 1_000_000)
  solve(input, expansion: expansion)
end

def distance(point1, point2, empty_rows, empty_columns, expansion)
  x, y = point1
  dx, dy = point2
  x_min, x_max = [x, dx].minmax
  y_min, y_max = [y, dy].minmax

  (x_max - x_min) + (y_max - y_min) +
    (empty_rows.count { it.between?(x_min, x_max) } * (expansion - 1)) +
    (empty_columns.count { it.between?(y_min, y_max) } * (expansion - 1))
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    ...#......
    .......#..
    #.........
    ..........
    ......#...
    .#........
    .........#
    ..........
    .......#..
    #...#.....
  INPUT

  def test_solve_example
    assert_equal 374, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 9_799_681, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 1030, solve2(EXAMPLE, expansion: 10)
    assert_equal 8410, solve2(EXAMPLE, expansion: 100)
  end

  def test_solve2_input
    assert_equal 513_171_773_355, solve2(read_file('input.txt'))
  end
end
