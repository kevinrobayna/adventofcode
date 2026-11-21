# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def parse_input(input)
  grid = input.split("\n").map(&:chars)
  start = finish = nil
  grid.each_with_index do |row, r|
    row.each_with_index do |c, col|
      start = [r, col] if c == 'S'
      finish = [r, col] if c == 'E'
    end
  end
  heights = grid.map { |row| row.map { |c| { 'S' => 'a', 'E' => 'z' }.fetch(c, c).ord - 'a'.ord } }
  [heights, start, finish]
end

# BFS backwards from the end: a step from a to b is allowed when height(b) <= height(a) + 1.
# Returns the distance from every reachable square to the end.
def distances_to(heights, finish)
  dist = { finish => 0 }
  queue = [finish]
  until queue.empty?
    r, c = queue.shift
    [[1, 0], [-1, 0], [0, 1], [0, -1]].each do |dr, dc|
      nr = r + dr
      nc = c + dc
      next if nr.negative? || nc.negative? || nr >= heights.size || nc >= heights[0].size
      next if dist.key?([nr, nc]) || heights[r][c] > heights[nr][nc] + 1

      dist[[nr, nc]] = dist[[r, c]] + 1
      queue << [nr, nc]
    end
  end
  dist
end

def solve(input)
  heights, start, finish = parse_input(input)
  distances_to(heights, finish)[start]
end

def solve2(input)
  heights, _, finish = parse_input(input)
  distances_to(heights, finish).select { |(r, c), _| heights[r][c].zero? }.values.min
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    Sabqponm
    abcryxxl
    accszExk
    acctuvwj
    abdefghi
  INPUT

  def test_solve_example
    assert_equal 31, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 420, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 29, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 414, solve2(read_file('input.txt'))
  end
end
