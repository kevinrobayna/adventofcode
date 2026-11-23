# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def parse(input)
  input.split("\n").reject(&:empty?).map(&:to_i)
end

def count_increases(numbers)
  numbers.each_cons(2).count { |a, b| a < b }
end

def solve(input)
  count_increases(parse(input))
end

def solve2(input)
  count_increases(parse(input).each_cons(3).map(&:sum))
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    199
    200
    208
    210
    200
    207
    240
    269
    260
    263
  INPUT

  def test_solve_example
    assert_equal 7, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 1559, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 5, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 1600, solve2(read_file('input.txt'))
  end
end
