# frozen_string_literal: true

require_relative '../../lib/aoc'

DIRECTIONS = { 'R' => [0, 1], 'D' => [1, 0], 'L' => [0, -1], 'U' => [-1, 0] }.freeze

# Shoelace for the interior area plus Pick's theorem to include the trench itself.
def lagoon(steps)
  x = 0
  y = 0
  area2 = 0
  perimeter = 0
  steps.each do |dir, len|
    dx, dy = DIRECTIONS[dir]
    nx = x + (dx * len)
    ny = y + (dy * len)
    area2 += (x * ny) - (nx * y)
    perimeter += len
    x = nx
    y = ny
  end
  (area2.abs / 2) + (perimeter / 2) + 1
end

def solve(input)
  lagoon(input.lines.map { |line| line.split.then { |d, n, _| [d, n.to_i] } })
end

def solve2(input)
  lagoon(input.lines.map do |line|
    hex = line[/#(\h{6})/, 1]
    ['RDLU'[hex[5].to_i], hex[0, 5].to_i(16)]
  end)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    R 6 (#70c710)
    D 5 (#0dc571)
    L 2 (#5713f0)
    D 2 (#d2c081)
    R 2 (#59c680)
    D 2 (#411b91)
    L 5 (#8ceee2)
    U 2 (#caa173)
    L 1 (#1b58a2)
    U 2 (#caa171)
    R 2 (#7807d2)
    U 3 (#a77fa3)
    L 2 (#015232)
    U 2 (#7a21e3)
  INPUT

  def test_solve_example
    assert_equal 62, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 52_231, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 952_408_144_115, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 57_196_493_937_398, solve2(read_file('input.txt'))
  end
end
