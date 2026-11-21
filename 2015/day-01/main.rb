# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def parse_input(input)
  input.strip.each_char.map { |char| char == '(' ? 1 : -1 }
end

def solve(input)
  parse_input(input).sum
end

def solve2(input)
  floor = 0
  parse_input(input).each_with_index do |value, id|
    floor += value
    return id + 1 if floor == -1
  end
  nil
end

class AoCTest < Minitest::Test
  EXAMPLE = '()())'

  def test_solve_example
    assert_equal(-1, solve(EXAMPLE))
    assert_equal 3, solve('))(((((')
  end

  def test_solve_input
    assert_equal 280, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 5, solve2(EXAMPLE)
    assert_equal 1, solve2(')')
  end

  def test_solve2_input
    assert_equal 1797, solve2(read_file('input.txt'))
  end
end
