# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def react(units)
  stack = []
  units.each_byte do |b|
    if stack.last && (stack.last ^ b) == 32
      stack.pop
    else
      stack << b
    end
  end
  stack.size
end

def solve(input)
  react(input.strip)
end

def solve2(input)
  polymer = input.strip
  ('a'..'z').map { |c| react(polymer.delete(c + c.upcase)) }.min
end

class AoCTest < Minitest::Test
  EXAMPLE = "dabAcCaCBAcCcaDA\n"

  def test_solve_example
    assert_equal 10, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 10_978, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 4, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 4840, solve2(read_file('input.txt'))
  end
end
