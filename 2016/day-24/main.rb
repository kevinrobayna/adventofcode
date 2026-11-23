# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def bfs(grid, start)
  dist = { start => 0 }
  queue = [start]
  until queue.empty?
    r, c = queue.shift
    [[r + 1, c], [r - 1, c], [r, c + 1], [r, c - 1]].each do |nr, nc|
      next if grid[nr][nc] == '#' || dist.key?([nr, nc])

      dist[[nr, nc]] = dist[[r, c]] + 1
      queue << [nr, nc]
    end
  end
  dist
end

def shortest_tour(input, return_home:)
  grid = input.lines.map(&:chomp)
  points = {}
  grid.each_with_index { |row, r| row.chars.each_with_index { |ch, c| points[ch.to_i] = [r, c] if ch.match?(/\d/) } }
  dist = points.transform_values { |pos| bfs(grid, pos) }
  others = points.keys - [0]
  others.permutation.map do |order|
    route = [0, *order]
    route << 0 if return_home
    route.each_cons(2).sum { |a, b| dist[a][points[b]] }
  end.min
end

def solve(input)
  shortest_tour(input, return_home: false)
end

def solve2(input)
  shortest_tour(input, return_home: true)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    ###########
    #0.1.....2#
    #.#######.#
    #4.......3#
    ###########
  INPUT

  def test_solve_example
    assert_equal 14, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 518, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 20, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 716, solve2(read_file('input.txt'))
  end
end
