# frozen_string_literal: true

require_relative '../../lib/aoc'

NEIGHBOURS = [-1, 0, 1].product([-1, 0, 1]) - [[0, 0]]

def parse_lights(input)
  rows = input.lines.map(&:strip)
  on = Set.new
  rows.each_with_index do |row, y|
    row.each_char.with_index { |c, x| on << [x, y] if c == '#' }
  end
  [on, rows.size]
end

def animate(on, size)
  counts = Hash.new(0)
  on.each do |x, y|
    NEIGHBOURS.each do |dx, dy|
      nx = x + dx
      ny = y + dy
      counts[[nx, ny]] += 1 if nx.between?(0, size - 1) && ny.between?(0, size - 1)
    end
  end
  counts.each_with_object(Set.new) do |(pos, n), next_on|
    next_on << pos if n == 3 || (n == 2 && on.include?(pos))
  end
end

def run_lights(input, steps, stuck_corners: false)
  on, size = parse_lights(input)
  corners = [0, size - 1].product([0, size - 1])
  on.merge(corners) if stuck_corners
  steps.times do
    on = animate(on, size)
    on.merge(corners) if stuck_corners
  end
  on.size
end

def solve(input, steps: 100)
  run_lights(input, steps)
end

def solve2(input, steps: 100)
  run_lights(input, steps, stuck_corners: true)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    .#.#.#
    ...##.
    #....#
    ..#...
    #.#..#
    ####..
  INPUT

  def test_solve_example
    assert_equal 4, solve(EXAMPLE, steps: 4)
  end

  def test_solve_input
    assert_equal 1061, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 17, solve2(EXAMPLE, steps: 5)
  end

  def test_solve2_input
    assert_equal 1006, solve2(read_file('input.txt'))
  end
end
