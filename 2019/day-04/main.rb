# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def non_decreasing?(digits) = digits.each_cons(2).all? { |a, b| a <= b }

def run_lengths(digits) = digits.chunk_while { |a, b| a == b }.map(&:size)

def valid?(password)
  digits = password.to_s.chars
  non_decreasing?(digits) && run_lengths(digits).any? { it >= 2 }
end

def valid2?(password)
  digits = password.to_s.chars
  non_decreasing?(digits) && run_lengths(digits).include?(2)
end

def range(input)
  lo, hi = input.strip.split('-').map(&:to_i)
  lo..hi
end

def solve(input)
  range(input).count { valid?(it) }
end

def solve2(input)
  range(input).count { valid2?(it) }
end

class AoCTest < Minitest::Test
  def test_solve_example
    assert valid?(111_111)
    refute valid?(223_450)
    refute valid?(123_789)
  end

  def test_solve_input
    assert_equal 1729, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert valid2?(112_233)
    refute valid2?(123_444)
    assert valid2?(111_122)
  end

  def test_solve2_input
    assert_equal 1172, solve2(read_file('input.txt'))
  end
end
