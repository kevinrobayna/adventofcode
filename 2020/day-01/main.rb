# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def find_product(input, size)
  input.split.map(&:to_i).combination(size).find { |c| c.sum == 2020 }.reduce(:*)
end

def solve(input)
  find_product(input, 2)
end

def solve2(input)
  find_product(input, 3)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    1721
    979
    366
    299
    675
    1456
  INPUT

  def test_solve_example
    assert_equal 514_579, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 713_184, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 241_861_950, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 261_244_452, solve2(read_file('input.txt'))
  end
end
