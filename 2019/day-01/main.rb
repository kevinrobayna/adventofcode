# frozen_string_literal: true

require_relative '../../lib/aoc'

def fuel(mass) = (mass / 3) - 2

def total_fuel(mass)
  total = 0
  while (mass = fuel(mass)).positive?
    total += mass
  end
  total
end

def solve(input)
  input.split.sum { fuel(it.to_i) }
end

def solve2(input)
  input.split.sum { total_fuel(it.to_i) }
end

class AoCTest < Minitest::Test
  def test_solve_example
    assert_equal 2, solve('12')
    assert_equal 2, solve('14')
    assert_equal 654, solve('1969')
    assert_equal 33_583, solve('100756')
    assert_equal 34_241, solve("12\n14\n1969\n100756\n")
  end

  def test_solve_input
    assert_equal 3_263_354, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 2, solve2('14')
    assert_equal 966, solve2('1969')
    assert_equal 50_346, solve2('100756')
  end

  def test_solve2_input
    assert_equal 4_892_166, solve2(read_file('input.txt'))
  end
end
