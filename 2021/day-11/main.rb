# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def parse(input)
  input.split("\n").map { |line| line.chars.map(&:to_i) }
end

# Advances one step in place and returns how many octopuses flashed.
def step(grid)
  flashing = []
  grid.each_with_index do |row, r|
    row.each_index do |c|
      row[c] += 1
      flashing << [r, c] if row[c] == 10
    end
  end
  flashed = 0
  until flashing.empty?
    r, c = flashing.pop
    flashed += 1
    (-1..1).each do |dr|
      (-1..1).each do |dc|
        nr = r + dr
        nc = c + dc
        next if (dr.zero? && dc.zero?) || !nr.between?(0, grid.size - 1) || !nc.between?(0, grid[0].size - 1)

        grid[nr][nc] += 1
        flashing << [nr, nc] if grid[nr][nc] == 10
      end
    end
  end
  grid.each { |row| row.map! { |v| v > 9 ? 0 : v } }
  flashed
end

def solve(input, steps: 100)
  grid = parse(input)
  Array.new(steps) { step(grid) }.sum
end

def solve2(input)
  grid = parse(input)
  size = grid.sum(&:size)
  1.step.find { step(grid) == size }
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    5483143223
    2745854711
    5264556173
    6141336146
    6357385478
    4167524645
    2176841721
    6882881134
    4846848554
    5283751526
  INPUT

  def test_solve_example
    assert_equal 204, solve(EXAMPLE, steps: 10)
    assert_equal 1656, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 1637, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 195, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 242, solve2(read_file('input.txt'))
  end
end
