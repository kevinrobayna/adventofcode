# frozen_string_literal: true

require_relative '../../lib/aoc'

def parse_boxes(input)
  input.lines.map { |line| line.split('x').map(&:to_i).sort }
end

def solve(input)
  parse_boxes(input).sum do |a, b, c|
    (2 * ((a * b) + (b * c) + (a * c))) + (a * b)
  end
end

def solve2(input)
  parse_boxes(input).sum { |a, b, c| (2 * (a + b)) + (a * b * c) }
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    2x3x4
    1x1x10
  INPUT

  def test_solve_example
    assert_equal 58 + 43, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 1_588_178, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 34 + 14, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 3_783_758, solve2(read_file('input.txt'))
  end
end
