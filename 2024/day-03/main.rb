# frozen_string_literal: true

require_relative '../../lib/aoc'

def solve(input)
  input.scan(/mul\((\d+),(\d+)\)/).sum { |a, b| a.to_i * b.to_i }
end

def solve2(input)
  enabled = true
  input.scan(/(mul\((\d+),(\d+)\)|do\(\)|don't\(\))/).sum do |match, a, b|
    enabled = true if match == 'do()'
    enabled = false if match == "don't()"
    match.start_with?('mul') && enabled ? a.to_i * b.to_i : 0
  end
end

class AoCTest < Minitest::Test
  EXAMPLE = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))\n"
  EXAMPLE2 = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))\n"

  def test_solve_example
    assert_equal 161, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 173_517_243, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 48, solve2(EXAMPLE2)
  end

  def test_solve2_input
    assert_equal 100_450_138, solve2(read_file('input.txt'))
  end
end
