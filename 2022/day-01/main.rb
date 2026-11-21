# frozen_string_literal: true

require_relative '../../lib/aoc'

def solve(input)
  sorted_snacks(input).last
end

def solve2(input)
  sorted_snacks(input).last(3).sum
end

def sorted_snacks(input)
  input.split("\n\n").map { |elf| elf.split.sum(&:to_i) }.sort
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    1000
    2000
    3000

    4000

    5000
    6000

    7000
    8000
    9000

    10000
  INPUT

  def test_solve_example
    assert_equal 24_000, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 69_836, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 45_000, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 207_968, solve2(read_file('input.txt'))
  end
end
