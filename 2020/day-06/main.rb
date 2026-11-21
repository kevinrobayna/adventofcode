# frozen_string_literal: true

require_relative '../../lib/aoc'

def groups(input)
  input.split("\n\n").map { |g| g.split.map(&:chars) }
end

def solve(input)
  groups(input).sum { |g| g.reduce(:|).size }
end

def solve2(input)
  groups(input).sum { |g| g.reduce(:&).size }
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    abc

    a
    b
    c

    ab
    ac

    a
    a
    a
    a

    b
  INPUT

  def test_solve_example
    assert_equal 11, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 6530, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 6, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 3323, solve2(read_file('input.txt'))
  end
end
