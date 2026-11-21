# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

# Returns [letters seen, steps taken].
def follow_tubes(input)
  grid = input.lines.map(&:chomp)
  at = ->(x, y) { y.between?(0, grid.size - 1) && x >= 0 ? grid[y][x] || ' ' : ' ' }
  x = grid[0].index('|')
  y = 0
  dx = 0
  dy = 1
  letters = +''
  steps = 0
  while at[x, y] != ' '
    c = at[x, y]
    letters << c if c.match?(/[A-Z]/)
    dx, dy = [[dy, dx], [-dy, -dx]].find { |ndx, ndy| at[x + ndx, y + ndy] != ' ' } if c == '+'
    x += dx
    y += dy
    steps += 1
  end
  [letters, steps]
end

def solve(input)
  follow_tubes(input)[0]
end

def solve2(input)
  follow_tubes(input)[1]
end

class AoCTest < Minitest::Test
  EXAMPLE = [
    '     |          ',
    '     |  +--+    ',
    '     A  |  C    ',
    ' F---|----E|--+ ',
    '     |  |  |  D ',
    '     +B-+  +--+ '
  ].join("\n")

  def test_solve_example
    assert_equal 'ABCDEF', solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 'EOCZQMURF', solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 38, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 16_312, solve2(read_file('input.txt'))
  end
end
