# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def invalid_number(numbers, preamble)
  (preamble...numbers.size).each do |i|
    window = numbers[i - preamble, preamble]
    return numbers[i] unless window.combination(2).any? { |a, b| a != b && a + b == numbers[i] }
  end
end

def solve(input, preamble: 25)
  invalid_number(input.split.map(&:to_i), preamble)
end

def solve2(input, preamble: 25)
  numbers = input.split.map(&:to_i)
  target = invalid_number(numbers, preamble)
  lo = 0
  sum = 0
  numbers.each_with_index do |n, hi|
    sum += n
    while sum > target && lo < hi
      sum -= numbers[lo]
      lo += 1
    end
    return numbers[lo..hi].minmax.sum if sum == target && hi > lo
  end
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    35
    20
    15
    25
    47
    40
    62
    55
    65
    95
    102
    117
    150
    182
    127
    219
    299
    277
    309
    576
  INPUT

  def test_solve_example
    assert_equal 127, solve(EXAMPLE, preamble: 5)
  end

  def test_solve_input
    assert_equal 776_203_571, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 62, solve2(EXAMPLE, preamble: 5)
  end

  def test_solve2_input
    assert_equal 104_800_569, solve2(read_file('input.txt'))
  end
end
