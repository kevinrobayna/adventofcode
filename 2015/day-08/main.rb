# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def memory_length(literal)
  literal[1..-2].gsub(/\\(\\|"|x\h\h)/, '.').length
end

def encoded_length(literal)
  literal.length + literal.count('"\\') + 2
end

def solve(input)
  input.lines.map(&:strip).sum { |line| line.length - memory_length(line) }
end

def solve2(input)
  input.lines.map(&:strip).sum { |line| encoded_length(line) - line.length }
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~'INPUT'
    ""
    "abc"
    "aaa\"aaa"
    "\x27"
  INPUT

  def test_solve_example
    assert_equal 12, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 1350, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 19, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 2085, solve2(read_file('input.txt'))
  end
end
