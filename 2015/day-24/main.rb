# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

# Smallest quantum entanglement of a minimum-size first group summing to total / groups.
# Assumes (as holds for real inputs) the remaining packages can be split evenly.
def best_entanglement(input, groups)
  weights = input.split.map(&:to_i).sort.reverse
  target = weights.sum / groups
  (1..weights.size).each do |size|
    products = weights.combination(size).select { |c| c.sum == target }.map { |c| c.reduce(:*) }
    return products.min if products.any?
  end
end

def solve(input)
  best_entanglement(input, 3)
end

def solve2(input)
  best_entanglement(input, 4)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    1
    2
    3
    4
    5
    7
    8
    9
    10
    11
  INPUT

  def test_solve_example
    assert_equal 99, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 11_846_773_891, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 44, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 80_393_059, solve2(read_file('input.txt'))
  end
end
