# frozen_string_literal: true

require_relative '../../lib/aoc'

SNAFU_DIGITS = { '=' => -2, '-' => -1, '0' => 0, '1' => 1, '2' => 2 }.freeze

def from_snafu(text)
  text.chars.reduce(0) { |acc, ch| (acc * 5) + SNAFU_DIGITS.fetch(ch) }
end

def to_snafu(number)
  return '0' if number.zero?

  digits = []
  while number.positive?
    rem = number % 5
    number /= 5
    if rem > 2
      rem -= 5
      number += 1
    end
    digits.unshift(SNAFU_DIGITS.key(rem))
  end
  digits.join
end

def solve(input)
  to_snafu(input.split.sum { |line| from_snafu(line) })
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    1=-0-2
    12111
    2=0=
    21
    2=01
    111
    20012
    112
    1=-1=
    1-12
    12
    1=
    122
  INPUT

  def test_conversions
    { 1 => '1', 3 => '1=', 8 => '2=', 2022 => '1=11-2', 314_159_265 => '1121-1110-1=0' }.each do |n, s|
      assert_equal s, to_snafu(n)
      assert_equal n, from_snafu(s)
    end
  end

  def test_solve_example
    assert_equal '2=-1=0', solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal '121=2=1==0=10=2-20=2', solve(read_file('input.txt'))
  end
end
