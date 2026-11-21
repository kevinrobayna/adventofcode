# frozen_string_literal: true

require_relative '../../lib/aoc'

def solve(input)
  input.length
end

def solve2(input)
  input.length
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
  INPUT

  def test_solve_example
    assert_equal 0, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 0, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 0, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 0, solve2(read_file('input.txt'))
  end
end
