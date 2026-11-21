# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

# Number of container combinations that hold exactly `liters`, grouped by container count.
def combinations_by_size(input, liters)
  containers = input.split.map(&:to_i)
  (1..containers.size).to_h do |k|
    [k, containers.combination(k).count { |combo| combo.sum == liters }]
  end
end

def solve(input, liters: 150)
  combinations_by_size(input, liters).values.sum
end

def solve2(input, liters: 150)
  combinations_by_size(input, liters).values.find(&:positive?)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    20
    15
    10
    5
    5
  INPUT

  def test_solve_example
    assert_equal 4, solve(EXAMPLE, liters: 25)
  end

  def test_solve_input
    assert_equal 1304, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 3, solve2(EXAMPLE, liters: 25)
  end

  def test_solve2_input
    assert_equal 18, solve2(read_file('input.txt'))
  end
end
