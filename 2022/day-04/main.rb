# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def pairs(input)
  input.split("\n").map { |line| line.scan(/\d+/).map(&:to_i) }
end

def solve(input)
  pairs(input).count { |a1, a2, b1, b2| (a1 <= b1 && b2 <= a2) || (b1 <= a1 && a2 <= b2) }
end

def solve2(input)
  pairs(input).count { |a1, a2, b1, b2| a1 <= b2 && b1 <= a2 }
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    2-4,6-8
    2-3,4-5
    5-7,7-9
    2-8,3-7
    6-6,4-6
    2-6,4-8
  INPUT

  def test_solve_example
    assert_equal 2, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 599, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 4, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 928, solve2(read_file('input.txt'))
  end
end
