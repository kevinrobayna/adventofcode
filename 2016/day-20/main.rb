# frozen_string_literal: true

require_relative '../../lib/aoc'

# Sorted, merged list of blocked [low, high] ranges.
def merged_ranges(input)
  ranges = input.scan(/(\d+)-(\d+)/).map { |a, b| [a.to_i, b.to_i] }.sort
  ranges.each_with_object([]) do |(lo, hi), merged|
    if merged.any? && lo <= merged.last[1] + 1
      merged.last[1] = [merged.last[1], hi].max
    else
      merged << [lo, hi]
    end
  end
end

def solve(input)
  first = merged_ranges(input).first
  first[0].positive? ? 0 : first[1] + 1
end

def solve2(input, max: 4_294_967_295)
  blocked = merged_ranges(input).sum { |lo, hi| [hi, max].min - lo + 1 if lo <= max }
  max + 1 - blocked
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    5-8
    0-2
    4-7
  INPUT

  def test_solve_example
    assert_equal 3, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 23_923_783, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 2, solve2(EXAMPLE, max: 9)
  end

  def test_solve2_input
    assert_equal 125, solve2(read_file('input.txt'))
  end
end
