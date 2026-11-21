# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def parse(input)
  input.lines.map { _1.split.map(&:to_i) }.transpose
end

def solve(input)
  left, right = parse(input)
  left.sort.zip(right.sort).sum { |l, r| (l - r).abs }
end

def solve2(input)
  left, right = parse(input)
  counts = right.tally
  left.sum { |l| l * counts.fetch(l, 0) }
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
  INPUT

  def test_solve_example
    assert_equal 11, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 1_341_714, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 31, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 27_384_707, solve2(read_file('input.txt'))
  end
end
