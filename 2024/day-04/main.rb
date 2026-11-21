# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

DIRECTIONS = [-1, 0, 1].product([-1, 0, 1]) - [[0, 0]]

def parse(input)
  input.lines.map { _1.strip.chars }
end

def at(grid, x, y)
  return nil if x.negative? || y.negative? || x >= grid.size || y >= grid[x].size

  grid[x][y]
end

def solve(input)
  grid = parse(input)
  grid.each_index.sum do |x|
    grid[x].each_index.sum do |y|
      DIRECTIONS.count do |dx, dy|
        'XMAS'.each_char.with_index.all? { |c, i| at(grid, x + (dx * i), y + (dy * i)) == c }
      end
    end
  end
end

def solve2(input)
  grid = parse(input)
  grid.each_index.sum do |x|
    grid[x].each_index.count do |y|
      next false unless grid[x][y] == 'A'

      diagonals = [
        [at(grid, x - 1, y - 1), at(grid, x + 1, y + 1)],
        [at(grid, x + 1, y - 1), at(grid, x - 1, y + 1)]
      ]
      diagonals.all? { _1.compact.sort == %w[M S] }
    end
  end
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
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

  def test_solve_small_example
    assert_equal 4, solve(<<~INPUT)
      ..X...
      .SAMX.
      .A..A.
      XMAS.S
      .X....
    INPUT
  end

  def test_solve_example
    assert_equal 18, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 2458, solve(read_file('input.txt'))
  end

  def test_solve2_small_example
    assert_equal 1, solve2("M.S\n.A.\nM.S\n")
  end

  def test_solve2_example
    assert_equal 9, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 1945, solve2(read_file('input.txt'))
  end
end
