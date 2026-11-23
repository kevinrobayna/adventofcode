# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def blink(stone)
  return [1] if stone.zero?

  digits = stone.to_s
  return [stone * 2024] if digits.size.odd?

  half = digits.size / 2
  [digits[0...half].to_i, digits[half..].to_i]
end

# Stone order never matters for the count, so track how many of each number there are.
def count_stones(input, blinks)
  counts = input.split.map(&:to_i).tally
  blinks.times do
    counts = counts.each_with_object(Hash.new(0)) do |(stone, n), acc|
      blink(stone).each { acc[_1] += n }
    end
  end
  counts.values.sum
end

def solve(input, blinks: 25)
  count_stones(input, blinks)
end

def solve2(input)
  count_stones(input, 75)
end

class AoCTest < Minitest::Test
  EXAMPLE = "125 17\n"

  def test_solve_example
    assert_equal 7, solve("0 1 10 99 999\n", blinks: 1)
    assert_equal 22, solve(EXAMPLE, blinks: 6)
    assert_equal 55_312, solve(EXAMPLE)
  end

  def test_solve2_example
    assert_equal 65_601_038_650_482, solve2(EXAMPLE)
  end

  def test_solve_input
    assert_equal 220_722, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 261_952_051_690_787, solve2(read_file('input.txt'))
  end
end
