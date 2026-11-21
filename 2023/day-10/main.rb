# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

UP = [-1, 0].freeze
DOWN = [1, 0].freeze
RIGHT = [0, 1].freeze
LEFT = [0, -1].freeze

DIR = {
  '|' => [UP, DOWN],
  '-' => [RIGHT, LEFT],
  'L' => [UP, RIGHT],
  'J' => [UP, LEFT],
  'F' => [DOWN, RIGHT],
  '7' => [DOWN, LEFT],
  '.' => [],
  'S' => []
}.freeze

def parse(input)
  grid = input.lines.map { it.strip.chars }
  x = grid.index { it.include?('S') }
  [[x, grid[x].index('S')], grid]
end

def neighbors(current, grid)
  x, y = current
  return [] if x.negative? || y.negative? || x >= grid.length || y >= grid.first.length

  DIR[grid[x][y]].map { |inc_x, inc_y| [x + inc_x, y + inc_y] }
end

def find_cycle(grid, start)
  start_neighbors = [UP, DOWN, LEFT, RIGHT].map { |dx, dy| [start.first + dx, start.last + dy] }
                                           .select { |pos| neighbors(pos, grid).include?(start) }

  current = start_neighbors.first
  pipe = Set[start, current]
  while current != start_neighbors.last
    neighbors(current, grid).each do |neighbor|
      next if pipe.include?(neighbor)

      pipe << neighbor
      current = neighbor
    end
  end
  pipe
end

def solve(input)
  start, grid = parse(input)
  find_cycle(grid, start).length / 2
end

# https://en.wikipedia.org/wiki/Point_in_polygon : cast a ray to the right and count crossings,
# separately for pipes facing north and south.
def solve2(input)
  start, grid = parse(input)
  cycle = find_cycle(grid, start)

  grid.each_with_index.sum do |row, x|
    row.each_index.count do |y|
      next false if cycle.include?([x, y])

      crossings = (y...row.size).select { cycle.include?([x, it]) }.map { row[it] }
      north = crossings.count { %w[J L |].include?(it) }
      south = crossings.count { %w[F 7 |].include?(it) }
      [north, south].min.odd?
    end
  end
end

class AoCTest < Minitest::Test
  def test_solve_example
    assert_equal 4, solve(<<~INPUT)
      .....
      .S-7.
      .|.|.
      .L-J.
      .....
    INPUT
    assert_equal 4, solve(<<~INPUT)
      -L|F7
      7S-7|
      L|7||
      -L-J|
      L|-JF
    INPUT
    assert_equal 8, solve(<<~INPUT)
      ..F7.
      .FJ|.
      SJ.L7
      |F--J
      LJ...
    INPUT
    assert_equal 8, solve(<<~INPUT)
      7-F7-
      .FJ|7
      SJLL7
      |F--J
      LJ.LJ
    INPUT
  end

  def test_solve_input
    assert_equal 6778, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 4, solve2(<<~INPUT)
      ...........
      .S-------7.
      .|F-----7|.
      .||.....||.
      .||.....||.
      .|L-7.F-J|.
      .|..|.|..|.
      .L--J.L--J.
      ...........
    INPUT
    assert_equal 8, solve2(<<~INPUT)
      .F----7F7F7F7F-7....
      .|F--7||||||||FJ....
      .||.FJ||||||||L7....
      FJL7L7LJLJ||LJ.L-7..
      L--J.L7...LJS7F-7L7.
      ....F-J..F7FJ|L7L7L7
      ....L7.F7||L7|.L7L7|
      .....|FJLJ|FJ|F7|.LJ
      ....FJL-7.||.||||...
      ....L---J.LJ.LJLJ...
    INPUT
    assert_equal 10, solve2(<<~INPUT)
      FF7FSF7F7F7F7F7F---7
      L|LJ||||||||||||F--J
      FL-7LJLJ||||||LJL-77
      F--JF--7||LJLJ7F7FJ-
      L---JF-JLJ.||-FJLJJ7
      |F|F-JF---7F7-L7L|7|
      |FFJF7L7F-JF7|JL---7
      7-L-JL7||F7|L7F-7F7|
      L.L7LFJ|||||FJL7||LJ
      L7JLJL-JLJLJL--JLJ.L
    INPUT
  end

  def test_solve2_input
    assert_equal 433, solve2(read_file('input.txt'))
  end
end
