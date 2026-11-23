# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

KEYPAD1 = <<~PAD
  123
  456
  789
PAD

KEYPAD2 = <<~PAD
  ..1..
  .234.
  56789
  .ABC.
  ..D..
PAD

MOVES = { 'U' => [-1, 0], 'D' => [1, 0], 'L' => [0, -1], 'R' => [0, 1] }.freeze

def press(input, keypad)
  grid = keypad.lines.map(&:chomp)
  r, c = grid.each_with_index.flat_map { |row, i| row.chars.each_index.map { |j| [i, j] } }.find { |i, j| grid[i][j] == '5' }
  input.lines.map(&:strip).reject(&:empty?).map do |line|
    line.each_char do |ch|
      dr, dc = MOVES.fetch(ch)
      nr = r + dr
      nc = c + dc
      next if nr.negative? || nc.negative? || nr >= grid.size || nc >= grid[nr].size || grid[nr][nc] == '.'

      r = nr
      c = nc
    end
    grid[r][c]
  end.join
end

def solve(input)
  press(input, KEYPAD1)
end

def solve2(input)
  press(input, KEYPAD2)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    ULL
    RRDDD
    LURDL
    UUUUD
  INPUT

  def test_solve_example
    assert_equal '1985', solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal '12578', solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal '5DB3', solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal '516DD', solve2(read_file('input.txt'))
  end
end
