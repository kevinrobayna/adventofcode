# frozen_string_literal: true

require 'pry'
require 'minitest/autorun'

def read_file(filename)
  # Get the directory of the currently executing script
  # Join the script directory with the filename
  # Read the content of the file
  File.read(File.join(__dir__, filename))
end

UP = [-1, 0].freeze
DOWN = [1, 0].freeze
RIGHT = [0, 1].freeze
LEFT = [0, -1].freeze
UP_LEFT = [-1, -1].freeze
UP_RIGHT = [-1, 1].freeze
DOWN_LEFT = [1, -1].freeze
DOWN_RIGHT = [1, 1].freeze

DIRECTIONS = [UP, DOWN, RIGHT, LEFT, UP_LEFT, UP_RIGHT, DOWN_LEFT, DOWN_RIGHT].freeze

def solve(input)
  grid = input.lines.map { _1.strip.chars }

  solution = 0
  grid.each_with_index do |row, x|
    row.each_with_index do |_, y|
      DIRECTIONS.each do |inc_x, inc_y|
        solution += 1 if xmas_direction?(grid, [x, y], [inc_x, inc_y])
      end
    end
  end

  solution
end

def xmas_direction?(grid, pos, direction)
  pos_x, pos_y = pos
  inc_x, inc_y = direction

  return false unless expected_char?(grid, pos, 'X')

  next_x = pos_x + inc_x
  next_y = pos_y + inc_y
  return false unless expected_char?(grid, [next_x, next_y], 'M')

  next_x = pos_x + (inc_x * 2)
  next_y = pos_y + (inc_y * 2)
  return false unless expected_char?(grid, [next_x, next_y], 'A')

  next_x = pos_x + (inc_x * 3)
  next_y = pos_y + (inc_y * 3)
  return false unless expected_char?(grid, [next_x, next_y], 'S')

  true
end

def expected_char?(grid, pos, char)
  next_x, next_y = pos

  return false if next_x.negative?
  return false if next_x >= grid.length
  return false if next_y.negative?
  return false if next_y >= grid.first.size

  grid[next_x][next_y] == char
end

def solve2(input)
  input.length
end

class AoCTest < Minitest::Test
  def test_solve
    test = <<~INPUT
      ..X...
      .SAMX.
      .A..A.
      XMAS.S
      .X....
    INPUT
    assert_equal 4, solve(test)
  end

  def test_complex_solve_without_random_fill
    test = <<~INPUT
      ....XXMAS.
      .SAMXMS...
      ...S..A...
      ..A.A.MS.X
      XMASAMX.MM
      X.....XA.A
      S.S.S.S.SS
      .A.A.A.A.A
      ..M.M.M.MM
      .X.X.XMASX
    INPUT
    assert_equal 18, solve(test)
  end

  def test_complex_solve
    test = <<~INPUT
      MMMSXXMASM
      MSAMXMSMSA
      AMXSXMAAMM
      MSAMASMSMX
      XMASAMXAMM
      XXAMMXXAMA
      SMSMSASXSS
      SAXAMASAAA
      MAMMMXMMMM
      MXMXAXMASX
    INPUT
    assert_equal 18, solve(test)
  end

  def test_solve2
    test = <<~INPUT
      M.S
      .A.
      M.S
    INPUT
    assert_equal 1, solve2(test)
  end

  def test_solve2_witout_random_fill
    test = <<~INPUT
      .M.S......
      ..A..MSMS.
      .M.S.MAA..
      ..A.ASMSM.
      .M.S.M....
      ..........
      S.S.S.S.S.
      .A.A.A.A..
      M.M.M.M.M.
      ..........
    INPUT
    assert_equal 9, solve2(test)
  end

  def test_solve2_complex_solve
    test = <<~INPUT
      MMMSXXMASM
      MSAMXMSMSA
      AMXSXMAAMM
      MSAMASMSMX
      XMASAMXAMM
      XXAMMXXAMA
      SMSMSASXSS
      SAXAMASAAA
      MAMMMXMMMM
      MXMXAXMASX
    INPUT
    assert_equal 9, solve(test)
  end
end

puts 'Part1', solve(read_file('input.txt'))
puts 'Part2', solve2(read_file('input.txt'))
