# frozen_string_literal: true

require_relative '../../lib/aoc'

def solve(input)
  earliest, buses = input.lines
  earliest = earliest.to_i
  bus = buses.split(',').reject { |b| b == 'x' }.map(&:to_i).min_by { |b| -earliest % b }
  bus * (-earliest % bus)
end

# Sieve over the (pairwise coprime) bus ids: t + offset ≡ 0 (mod bus).
def solve2(input)
  buses = input.lines.last.strip.split(',').each_with_index.reject { |b, _| b == 'x' }.map { |b, i| [b.to_i, i] }
  t = 0
  step = 1
  buses.each do |bus, offset|
    t += step until ((t + offset) % bus).zero?
    step = step.lcm(bus)
  end
  t
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    939
    7,13,x,x,59,x,31,19
  INPUT

  def test_solve_example
    assert_equal 295, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 3882, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 1_068_781, solve2(EXAMPLE)
    assert_equal 3417, solve2("0\n17,x,13,19\n")
    assert_equal 754_018, solve2("0\n67,7,59,61\n")
    assert_equal 779_210, solve2("0\n67,x,7,59,61\n")
    assert_equal 1_261_476, solve2("0\n67,7,x,59,61\n")
    assert_equal 1_202_161_486, solve2("0\n1789,37,47,1889\n")
  end

  def test_solve2_input
    assert_equal 867_295_486_378_319, solve2(read_file('input.txt'))
  end
end
