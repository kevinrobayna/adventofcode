# frozen_string_literal: true

require_relative '../../lib/aoc'

# Yields the [x, y] coordinates of the spiral squares in order, starting at square 1.
def spiral
  return enum_for(:spiral) unless block_given?

  x = y = 0
  dx = 1
  dy = 0
  len = 1
  yield [x, y]
  loop do
    2.times do
      len.times do
        x += dx
        y += dy
        yield [x, y]
      end
      dx, dy = -dy, dx
    end
    len += 1
  end
end

def solve(input)
  n = input.to_i
  x, y = spiral.lazy.drop(n - 1).first
  x.abs + y.abs
end

def solve2(input)
  n = input.to_i
  values = Hash.new(0)
  values[[0, 0]] = 1
  spiral.each do |x, y|
    next if x.zero? && y.zero?

    v = [-1, 0, 1].product([-1, 0, 1]).sum { |dx, dy| values[[x + dx, y + dy]] }
    return v if v > n

    values[[x, y]] = v
  end
end

class AoCTest < Minitest::Test
  def test_solve_example
    assert_equal 0, solve('1')
    assert_equal 3, solve('12')
    assert_equal 2, solve('23')
    assert_equal 31, solve('1024')
  end

  def test_solve_input
    assert_equal 371, solve(read_file('input.txt'))
  end

  def test_solve2_example
    # First value written larger than the input; sequence 1, 1, 2, 4, 5, 10, 11, 23, 25, 26, 54, ...
    assert_equal 4, solve2('2')
    assert_equal 26, solve2('25')
    assert_equal 54, solve2('26')
  end

  def test_solve2_input
    assert_equal 369_601, solve2(read_file('input.txt'))
  end
end
