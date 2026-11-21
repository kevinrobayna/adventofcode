# frozen_string_literal: true

require_relative '../../lib/aoc'

# Greedily picks the largest digit that still leaves room for the remaining picks.
def max_joltage(bank, count)
  digits = bank.chars.map(&:to_i)
  start = 0
  count.downto(1).reduce(0) do |acc, remaining|
    window = digits[start..(digits.size - remaining)]
    best = window.max
    start += window.index(best) + 1
    (acc * 10) + best
  end
end

def solve(input, count: 2)
  input.split.sum { |bank| max_joltage(bank, count) }
end

def solve2(input)
  solve(input, count: 12)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    987654321111111
    811111111111119
    234234234234278
    818181911112111
  INPUT

  def test_solve_example
    assert_equal 357, solve(EXAMPLE)
  end

  def test_solve2_example
    assert_equal 3_121_910_778_619, solve2(EXAMPLE)
  end

  def test_solve_input
    assert_equal 17_085, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 169_408_143_086_082, solve2(read_file('input.txt'))
  end
end
