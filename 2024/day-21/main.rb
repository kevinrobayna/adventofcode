# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

NUMERIC = { '7' => [0, 0], '8' => [0, 1], '9' => [0, 2], '4' => [1, 0], '5' => [1, 1], '6' => [1, 2],
            '1' => [2, 0], '2' => [2, 1], '3' => [2, 2], '0' => [3, 1], 'A' => [3, 2] }.freeze
NUMERIC_GAP = [3, 0].freeze
DIRECTIONAL = { '^' => [0, 1], 'A' => [0, 2], '<' => [1, 0], 'v' => [1, 1], '>' => [1, 2] }.freeze
DIRECTIONAL_GAP = [0, 0].freeze

# Candidate key sequences (ending in A) to move between two keys: all horizontal moves then all
# vertical ones, or the reverse, skipping whichever order would pass over the gap.
def candidate_paths(from, to, gap)
  (r1, c1), (r2, c2) = from, to
  vertical = (r2 > r1 ? 'v' : '^') * (r2 - r1).abs
  horizontal = (c2 > c1 ? '>' : '<') * (c2 - c1).abs
  paths = []
  paths << "#{horizontal}#{vertical}A" unless [r1, c2] == gap
  paths << "#{vertical}#{horizontal}A" unless [r2, c1] == gap
  paths.uniq
end

# Minimum presses on the human keypad to type `sequence` on a directional keypad that sits
# `depth` robots away from the human.
def sequence_cost(sequence, depth, memo)
  return sequence.size if depth.zero?

  memo[[sequence, depth]] ||= "A#{sequence}".chars.each_cons(2).sum do |a, b|
    candidate_paths(DIRECTIONAL[a], DIRECTIONAL[b], DIRECTIONAL_GAP).map { sequence_cost(_1, depth - 1, memo) }.min
  end
end

def code_cost(code, robots, memo)
  "A#{code}".chars.each_cons(2).sum do |a, b|
    candidate_paths(NUMERIC[a], NUMERIC[b], NUMERIC_GAP).map { sequence_cost(_1, robots, memo) }.min
  end
end

def complexity(input, robots)
  memo = {}
  input.split.sum { |code| code_cost(code, robots, memo) * code.to_i }
end

def solve(input)
  complexity(input, 2)
end

def solve2(input)
  complexity(input, 25)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    029A
    980A
    179A
    456A
    379A
  INPUT

  def test_code_cost
    assert_equal 68, code_cost('029A', 2, {})
    assert_equal 64, code_cost('379A', 2, {})
  end

  def test_solve_example
    assert_equal 126_384, solve(EXAMPLE)
  end

  def test_solve2_example
    assert_equal 154_115_708_116_294, solve2(EXAMPLE)
  end

  def test_solve_input
    assert_equal 138_764, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 169_137_886_514_152, solve2(read_file('input.txt'))
  end
end
