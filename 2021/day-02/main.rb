# frozen_string_literal: true

require_relative '../../lib/aoc'

# Each command becomes [dx, dy] where dy is positive going down.
def parse(input)
  input.split("\n").map do |line|
    direction, amount = line.split
    amount = amount.to_i
    case direction
    when 'forward' then [amount, 0]
    when 'up' then [0, -amount]
    when 'down' then [0, amount]
    else raise "Unknown direction #{direction}"
    end
  end
end

def solve(input)
  x = y = 0
  parse(input).each do |dx, dy|
    x += dx
    y += dy
  end
  x * y
end

def solve2(input)
  aim = depth = position = 0
  parse(input).each do |dx, dy|
    aim += dy
    position += dx
    depth += aim * dx
  end
  position * depth
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    forward 5
    down 5
    forward 8
    up 3
    down 8
    forward 2
  INPUT

  def test_solve_example
    assert_equal 150, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 1_728_414, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 900, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 1_765_720_035, solve2(read_file('input.txt'))
  end
end
