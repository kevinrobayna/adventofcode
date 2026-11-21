# frozen_string_literal: true

require_relative '../../lib/aoc'

DIRS = [-1, 0, 1].product([-1, 0, 1]) - [[0, 0]]

# Precomputes, for each seat, the seats it watches; then iterates until stable.
def stabilize(input, tolerance:, line_of_sight:)
  grid = input.split.map(&:chars)
  rows = grid.size
  cols = grid[0].size
  seats = []
  grid.each_with_index { |row, r| row.each_with_index { |c, k| seats << [r, k] if c == 'L' } }
  index = seats.each_with_index.to_h
  neighbours = seats.map do |r, c|
    DIRS.filter_map do |dr, dc|
      nr = r + dr
      nc = c + dc
      while line_of_sight && nr.between?(0, rows - 1) && nc.between?(0, cols - 1) && grid[nr][nc] == '.'
        nr += dr
        nc += dc
      end
      index[[nr, nc]]
    end
  end
  occupied = Array.new(seats.size, false)
  loop do
    nxt = occupied.each_with_index.map do |occ, i|
      count = neighbours[i].count { |j| occupied[j] }
      occ ? count < tolerance : count.zero?
    end
    return nxt.count(true) if nxt == occupied

    occupied = nxt
  end
end

def solve(input)
  stabilize(input, tolerance: 4, line_of_sight: false)
end

def solve2(input)
  stabilize(input, tolerance: 5, line_of_sight: true)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    L.LL.LL.LL
    LLLLLLL.LL
    L.L.L..L..
    LLLL.LL.LL
    L.LL.LL.LL
    L.LLLLL.LL
    ..L.L.....
    LLLLLLLLLL
    L.LLLLLL.L
    L.LLLLL.LL
  INPUT

  def test_solve_example
    assert_equal 37, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 2483, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 26, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 2285, solve2(read_file('input.txt'))
  end
end
