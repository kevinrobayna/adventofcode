# frozen_string_literal: true

require_relative '../../lib/aoc'

MOVEMENTS = {
  'R' => [1, 0],
  'L' => [-1, 0],
  'U' => [0, 1],
  'D' => [0, -1]
}.freeze

def tail_positions(input, knot_count)
  knots = Array.new(knot_count) { [0, 0] }
  visited = Set[[0, 0]]
  input.each_line do |line|
    direction, steps = line.split
    dx, dy = MOVEMENTS[direction]
    steps.to_i.times do
      knots[0] = [knots[0][0] + dx, knots[0][1] + dy]
      (1...knot_count).each do |i|
        hx, hy = knots[i - 1]
        tx, ty = knots[i]
        next if [(hx - tx).abs, (hy - ty).abs].max <= 1

        # Move one step towards the knot ahead on each axis.
        knots[i] = [tx + (hx <=> tx), ty + (hy <=> ty)]
      end
      visited << knots.last
    end
  end
  visited.size
end

def solve(input)
  tail_positions(input, 2)
end

def solve2(input)
  tail_positions(input, 10)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    R 4
    U 4
    L 3
    D 1
    R 4
    D 1
    L 5
    R 2
  INPUT

  EXAMPLE2 = <<~INPUT
    R 5
    U 8
    L 8
    D 3
    R 17
    D 10
    L 25
    U 20
  INPUT

  def test_solve_example
    assert_equal 13, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 5883, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 1, solve2(EXAMPLE)
    assert_equal 36, solve2(EXAMPLE2)
  end

  def test_solve2_input
    assert_equal 2367, solve2(read_file('input.txt'))
  end
end
