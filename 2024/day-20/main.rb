# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

# Distance from the start along the single track for every open cell (nil for walls).
def track(input)
  grid = input.lines.map(&:chomp)
  cols = grid[0].size
  start = grid.join.index('S')
  dist = Array.new(grid.size * cols)
  pos = start
  steps = 0
  until pos.nil?
    dist[pos] = steps
    steps += 1
    pos = [pos - cols, pos + cols, pos - 1, pos + 1].find { |n| grid[n / cols][n % cols] != '#' && dist[n].nil? }
  end
  [dist, grid.size, cols]
end

# Counts cheats of up to `max_cheat` steps through walls that save at least `min_save`.
def count_cheats(input, max_cheat, min_save)
  dist, rows, cols = track(input)
  offsets = (-max_cheat..max_cheat).flat_map do |dr|
    span = max_cheat - dr.abs
    (-span..span).map { |dc| [dr, dc, dr.abs + dc.abs] }
  end
  count = 0
  dist.each_with_index do |from, pos|
    next unless from

    r, c = pos.divmod(cols)
    offsets.each do |dr, dc, d|
      nr = r + dr
      nc = c + dc
      next if nr.negative? || nc.negative? || nr >= rows || nc >= cols

      to = dist[(nr * cols) + nc]
      count += 1 if to && to - from - d >= min_save
    end
  end
  count
end

def solve(input, min_save: 100)
  count_cheats(input, 2, min_save)
end

def solve2(input, min_save: 100)
  count_cheats(input, 20, min_save)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    ###############
    #...#...#.....#
    #.#.#.#.#.###.#
    #S#...#.#.#...#
    #######.#.#.###
    #######.#.#...#
    #######.#.###.#
    ###..E#...#...#
    ###.#######.###
    #...###...#...#
    #.#####.#.###.#
    #.#...#.#.#...#
    #.#.#.#.#.#.###
    #...#...#...###
    ###############
  INPUT

  def test_solve_example
    assert_equal 44, solve(EXAMPLE, min_save: 1)
    assert_equal 5, solve(EXAMPLE, min_save: 20)
    assert_equal 1, solve(EXAMPLE, min_save: 64)
  end

  def test_solve2_example
    assert_equal 285, solve2(EXAMPLE, min_save: 50)
    assert_equal 3, solve2(EXAMPLE, min_save: 76)
  end

  def test_solve_input
    assert_equal 1485, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 1_027_501, solve2(read_file('input.txt'))
  end
end
