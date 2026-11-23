# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def solve(input)
  grid = input.split("\n").map(&:chars)
  rows = grid.size
  cols = grid[0].size
  1.step do |turn|
    moved = false
    [['>', 0, 1], ['v', 1, 0]].each do |herd, dr, dc|
      movers = []
      grid.each_with_index do |row, r|
        row.each_with_index do |cell, c|
          movers << [r, c] if cell == herd && grid[(r + dr) % rows][(c + dc) % cols] == '.'
        end
      end
      movers.each do |r, c|
        grid[r][c] = '.'
        grid[(r + dr) % rows][(c + dc) % cols] = herd
      end
      moved ||= movers.any?
    end
    return turn unless moved
  end
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    v...>>.vv>
    .vv>>.vv..
    >>.>v>...v
    >>v>>.>.v.
    v>v.vv.v..
    >.>>..v...
    .vv..>.>v.
    v.v..>>v.v
    ....v..v.>
  INPUT

  def test_solve_example
    assert_equal 58, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 471, solve(read_file('input.txt'))
  end
end
