# frozen_string_literal: true

require_relative '../../lib/aoc'

# Plots reachable in exactly `steps` steps on the infinitely tiled map (BFS + parity).
def reachable(input, steps)
  grid = input.lines.map(&:strip)
  rows = grid.length
  cols = grid.first.length
  start_row = grid.index { it.include?('S') }
  start = [start_row, grid[start_row].index('S')]
  seen = { start => 0 }
  frontier = [start]
  count = steps.even? ? 1 : 0
  (1..steps).each do |step|
    next_frontier = []
    frontier.each do |r, c|
      [[r + 1, c], [r - 1, c], [r, c + 1], [r, c - 1]].each do |pos|
        next if seen.key?(pos) || grid[pos[0] % rows][pos[1] % cols] == '#'

        seen[pos] = step
        next_frontier << pos
        count += 1 if step.even? == steps.even?
      end
    end
    frontier = next_frontier
  end
  count
end

def solve(input, steps: 64)
  reachable(input, steps)
end

BRUTE_FORCE_LIMIT = 1000

# The real input is square with S in the centre and clear centre row/column, so the count grows
# quadratically in whole-tile increments: fit f(rem), f(rem + n), f(rem + 2n) and extrapolate.
def solve2(input, steps: 26_501_365)
  return reachable(input, steps) if steps <= BRUTE_FORCE_LIMIT

  n = input.lines.length
  rem = steps % n

  a, b, c = (0..2).map { reachable(input, rem + (it * n)) }
  x = steps / n
  a + (x * (b - a)) + (x * (x - 1) / 2 * (c - (2 * b) + a))
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    ...........
    .....###.#.
    .###.##..#.
    ..#.#...#..
    ....#.#....
    .##..S####.
    .##..#...#.
    .......##..
    .##.#.####.
    .##..##.##.
    ...........
  INPUT

  def test_solve_example
    assert_equal 16, solve(EXAMPLE, steps: 6)
  end

  def test_solve_input
    assert_equal 3562, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 16, solve2(EXAMPLE, steps: 6)
    assert_equal 50, solve2(EXAMPLE, steps: 10)
    assert_equal 1594, solve2(EXAMPLE, steps: 50)
    assert_equal 6536, solve2(EXAMPLE, steps: 100)
  end

  def test_solve2_input
    assert_equal 592_723_929_260_582, solve2(read_file('input.txt'))
  end
end
