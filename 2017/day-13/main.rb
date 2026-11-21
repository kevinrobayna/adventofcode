# frozen_string_literal: true

require_relative '../../lib/aoc'

def firewall(input)
  input.scan(/(\d+): (\d+)/).map { |d, r| [d.to_i, r.to_i] }
end

def caught?(depth, range, delay)
  ((depth + delay) % (2 * (range - 1))).zero?
end

def solve(input)
  firewall(input).sum { |d, r| caught?(d, r, 0) ? d * r : 0 }
end

def solve2(input)
  layers = firewall(input).sort_by { |_, r| r }
  (0..).find { |delay| layers.none? { |d, r| caught?(d, r, delay) } }
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    0: 3
    1: 2
    4: 4
    6: 4
  INPUT

  def test_solve_example
    assert_equal 24, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 1_840, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 10, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 3_850_260, solve2(read_file('input.txt'))
  end
end
