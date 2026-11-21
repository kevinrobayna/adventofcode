# frozen_string_literal: true

require_relative '../../lib/aoc'

# Returns [cycles until a repeat is seen, length of the loop].
def reallocate(input)
  banks = input.split.map(&:to_i)
  seen = {}
  until seen.key?(banks)
    seen[banks.dup] = seen.size
    i = banks.index(banks.max)
    blocks = banks[i]
    banks[i] = 0
    blocks.times { |k| banks[(i + 1 + k) % banks.size] += 1 }
  end
  [seen.size, seen.size - seen[banks]]
end

def solve(input)
  reallocate(input)[0]
end

def solve2(input)
  reallocate(input)[1]
end

class AoCTest < Minitest::Test
  EXAMPLE = "0 2 7 0\n"

  def test_solve_example
    assert_equal 5, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 6_681, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 4, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 2_392, solve2(read_file('input.txt'))
  end
end
