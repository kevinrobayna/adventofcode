# frozen_string_literal: true

require_relative '../../lib/aoc'

def parse(input)
  input.lines.map { it.strip.chars }
end

# Rolls every 'O' as far west as it can go in each row.
def tilt_west(grid)
  grid.map do |row|
    row.join.split(/(#)/).map { |seg| seg == '#' ? seg : seg.chars.sort.reverse.join }.join.ljust(row.length, '.').chars
  end
end

def tilt_north(grid)
  tilt_west(grid.transpose).transpose
end

def load(grid)
  grid.each_with_index.sum { |row, i| row.count('O') * (grid.length - i) }
end

# North, west, south, east == four times (tilt north, then rotate clockwise).
def spin(grid)
  4.times { grid = tilt_north(grid).transpose.map(&:reverse) }
  grid
end

def solve(input)
  load(tilt_north(parse(input)))
end

def solve2(input, cycles: 1_000_000_000)
  grid = parse(input)
  seen = {}
  history = []
  until seen.key?(grid)
    seen[grid] = history.length
    history << grid
    grid = spin(grid)
  end
  start = seen[grid]
  load(history[start + ((cycles - start) % (history.length - start))])
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    O....#....
    O.OO#....#
    .....##...
    OO.#O....O
    .O.....O#.
    O.#..O.#.#
    ..O..#O..O
    .......O..
    #....###..
    #OO..#....
  INPUT

  def test_solve_example
    assert_equal 136, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 110_407, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 64, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 87_273, solve2(read_file('input.txt'))
  end
end
