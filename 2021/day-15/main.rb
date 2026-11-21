# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end
require_relative '../min_heap'

def lowest_risk(grid)
  rows = grid.size
  cols = grid[0].size
  dist = Array.new(rows * cols, Float::INFINITY)
  dist[0] = 0
  heap = MinHeap.new
  heap.push([0, 0])
  target = (rows * cols) - 1
  until heap.empty?
    d, idx = heap.pop
    return d if idx == target
    next if d > dist[idx]

    r, c = idx.divmod(cols)
    [[r - 1, c], [r + 1, c], [r, c - 1], [r, c + 1]].each do |nr, nc|
      next unless nr.between?(0, rows - 1) && nc.between?(0, cols - 1)

      nd = d + grid[nr][nc]
      nidx = (nr * cols) + nc
      next unless nd < dist[nidx]

      dist[nidx] = nd
      heap.push([nd, nidx])
    end
  end
end

def parse(input)
  input.split("\n").map { |line| line.chars.map(&:to_i) }
end

def solve(input)
  lowest_risk(parse(input))
end

def solve2(input)
  tile = parse(input)
  rows = tile.size
  cols = tile[0].size
  grid = Array.new(rows * 5) do |r|
    Array.new(cols * 5) { |c| ((tile[r % rows][c % cols] + (r / rows) + (c / cols) - 1) % 9) + 1 }
  end
  lowest_risk(grid)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    1163751742
    1381373672
    2136511328
    3694931569
    7463417111
    1319128137
    1359912421
    3125421639
    1293138521
    2311944581
  INPUT

  def test_solve_example
    assert_equal 40, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 472, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 315, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 2851, solve2(read_file('input.txt'))
  end
end
