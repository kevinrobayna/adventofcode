# frozen_string_literal: true

require_relative '../../lib/aoc'

DIRS = [[-1, 0], [0, 1], [1, 0], [0, -1]].freeze

def parse(input)
  grid = input.lines.map(&:chomp)
  start = nil
  grid.each_with_index { |row, r| (c = row.index('^')) && (start = [r, c]) }
  [grid.map { |row| row.chars.map { _1 == '#' } }, start]
end

# Walks from (r, c, d) and yields each newly entered cell with the state before the step.
# Returns :loop if the guard cycles, :exit otherwise.
def walk(walls, r, c, d, extra = nil)
  rows = walls.size
  cols = walls[0].size
  seen = {}
  loop do
    key = (((r * cols) + c) * 4) + d
    return :loop if seen[key]

    seen[key] = true
    dr, dc = DIRS[d]
    nr = r + dr
    nc = c + dc
    return :exit if nr.negative? || nc.negative? || nr >= rows || nc >= cols

    if walls[nr][nc] || (extra && extra[0] == nr && extra[1] == nc)
      d = (d + 1) % 4
    else
      yield(nr, nc, r, c, d) if block_given?
      r = nr
      c = nc
    end
  end
end

def path(walls, start)
  firsts = { start => nil }
  walk(walls, *start, 0) { |nr, nc, r, c, d| firsts[[nr, nc]] ||= [r, c, d] }
  firsts
end

def solve(input)
  path(*parse(input)).size
end

def solve2(input)
  walls, start = parse(input)
  path(walls, start).count do |cell, before|
    before && walk(walls, *before, cell) == :loop
  end
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...
  INPUT

  def test_solve_example
    assert_equal 41, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 5212, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 6, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 1767, solve2(read_file('input.txt'))
  end
end
