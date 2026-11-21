# frozen_string_literal: true

require_relative '../../lib/aoc'

def parse(input)
  input.split("\n").map { |line| line.chars.map(&:to_i) }
end

def neighbors(grid, r, c)
  [[r - 1, c], [r + 1, c], [r, c - 1], [r, c + 1]].select do |nr, nc|
    nr.between?(0, grid.size - 1) && nc.between?(0, grid[0].size - 1)
  end
end

def low_points(grid)
  grid.each_index.flat_map do |r|
    grid[r].each_index.select { |c| neighbors(grid, r, c).all? { |nr, nc| grid[nr][nc] > grid[r][c] } }.map { |c| [r, c] }
  end
end

def solve(input)
  grid = parse(input)
  low_points(grid).sum { |r, c| grid[r][c] + 1 }
end

def basin_size(grid, start)
  seen = Set[start]
  stack = [start]
  until stack.empty?
    r, c = stack.pop
    neighbors(grid, r, c).each do |n|
      next if grid[n[0]][n[1]] == 9 || seen.include?(n)

      seen << n
      stack << n
    end
  end
  seen.size
end

def solve2(input)
  grid = parse(input)
  low_points(grid).map { |p| basin_size(grid, p) }.max(3).reduce(:*)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    2199943210
    3987894921
    9856789892
    8767896789
    9899965678
  INPUT

  def test_solve_example
    assert_equal 15, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 518, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 1134, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 949_905, solve2(read_file('input.txt'))
  end
end
