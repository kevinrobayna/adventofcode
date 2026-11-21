# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def parse(input)
  input.lines.map { |line| line.chomp.chars.map { _1 == '.' ? -1 : _1.to_i } }
end

# Returns, for each trailhead, the list of 9-height cells reached by every distinct trail.
def trail_ends(input)
  grid = parse(input)
  climb = lambda do |r, c|
    h = grid[r][c]
    return [[r, c]] if h == 9

    [[r - 1, c], [r + 1, c], [r, c - 1], [r, c + 1]].flat_map do |nr, nc|
      next [] if nr.negative? || nc.negative? || nr >= grid.size || nc >= grid[nr].size
      next [] unless grid[nr][nc] == h + 1

      climb.call(nr, nc)
    end
  end
  grid.each_index.flat_map do |r|
    grid[r].each_index.select { grid[r][_1].zero? }.map { climb.call(r, _1) }
  end
end

def solve(input)
  trail_ends(input).sum { _1.uniq.size }
end

def solve2(input)
  trail_ends(input).sum(&:size)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    89010123
    78121874
    87430965
    96549874
    45678903
    32019012
    01329801
    10456732
  INPUT

  def test_solve_example
    assert_equal 1, solve("0123\n1234\n8765\n9876\n")
    assert_equal 4, solve(<<~INPUT)
      ..90..9
      ...1.98
      ...2..7
      6543456
      765.987
      876....
      987....
    INPUT
    assert_equal 3, solve(<<~INPUT)
      10..9..
      2...8..
      3...7..
      4567654
      ...8..3
      ...9..2
      .....01
    INPUT
    assert_equal 36, solve(EXAMPLE)
  end

  def test_solve2_example
    assert_equal 3, solve2(<<~INPUT)
      .....0.
      ..4321.
      ..5..2.
      ..6543.
      ..7..4.
      ..8765.
      ..9....
    INPUT
    assert_equal 227, solve2(<<~INPUT)
      012345
      123456
      234567
      345678
      4.6789
      56789.
    INPUT
    assert_equal 81, solve2(EXAMPLE)
  end

  def test_solve_input
    assert_equal 582, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 1302, solve2(read_file('input.txt'))
  end
end
