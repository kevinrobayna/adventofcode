# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def calculate_ways(times, distances)
  times.zip(distances).reduce(1) do |acc, (t, d)|
    acc * (1...t).count { |hold| (t - hold) * hold > d }
  end
end

def solve(input)
  times, distances = input.lines.map { it.scan(/\d+/).map(&:to_i) }
  calculate_ways(times, distances)
end

def solve2(input)
  time, distance = input.lines.map { it.scan(/\d+/).join.to_i }
  calculate_ways([time], [distance])
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    Time:      7  15   30
    Distance:  9  40  200
  INPUT

  def test_solve_example
    assert_equal 288, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 303_600, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 71_503, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 23_654_842, solve2(read_file('input.txt'))
  end
end
