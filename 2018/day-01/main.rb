# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def changes(input)
  input.split(/[\s,]+/).reject(&:empty?).map(&:to_i)
end

def solve(input)
  changes(input).sum
end

def solve2(input)
  seen = Set[0]
  freq = 0
  changes(input).cycle do |c|
    freq += c
    return freq unless seen.add?(freq)
  end
end

class AoCTest < Minitest::Test
  def test_solve_example
    assert_equal 3, solve("+1\n-2\n+3\n+1\n")
    assert_equal 0, solve("+1\n+1\n-2\n")
    assert_equal(-6, solve("-1\n-2\n-3\n"))
  end

  def test_solve_input
    assert_equal 486, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 2, solve2("+1\n-2\n+3\n+1\n")
    assert_equal 0, solve2("+1\n-1\n")
    assert_equal 10, solve2("+3\n+3\n+4\n-2\n-4\n")
    assert_equal 5, solve2("-6\n+3\n+8\n+5\n-6\n")
    assert_equal 14, solve2("+7\n+7\n-2\n-7\n-4\n")
  end

  def test_solve2_input
    assert_equal 69_285, solve2(read_file('input.txt'))
  end
end
