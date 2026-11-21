# frozen_string_literal: true

require_relative '../../lib/aoc'

INSTRUCTION = /(turn on|turn off|toggle) (\d+),(\d+) through (\d+),(\d+)/

def run_lights(input, actions)
  grid = Array.new(1000) { Array.new(1000, 0) }
  input.scan(INSTRUCTION).each do |op, *coords|
    x1, y1, x2, y2 = coords.map(&:to_i)
    action = actions.fetch(op)
    (y1..y2).each do |y|
      row = grid[y]
      (x1..x2).each { |x| row[x] = action.call(row[x]) }
    end
  end
  grid.sum(&:sum)
end

def solve(input)
  run_lights(input, 'turn on' => ->(_) { 1 }, 'turn off' => ->(_) { 0 }, 'toggle' => ->(v) { 1 - v })
end

def solve2(input)
  run_lights(input, 'turn on' => ->(v) { v + 1 }, 'turn off' => ->(v) { [v - 1, 0].max }, 'toggle' => ->(v) { v + 2 })
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    turn on 0,0 through 999,999
    toggle 0,0 through 999,0
    turn off 499,499 through 500,500
  INPUT

  def test_solve_example
    assert_equal 1_000_000 - 1000 - 4, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 400_410, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 1, solve2('turn on 0,0 through 0,0')
    assert_equal 2_000_000, solve2('toggle 0,0 through 999,999')
  end

  def test_solve2_input
    assert_equal 15_343_601, solve2(read_file('input.txt'))
  end
end
