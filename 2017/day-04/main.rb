# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def count_valid(input, &key)
  input.lines.map(&:split).reject(&:empty?).count do |words|
    keys = words.map(&key)
    keys.uniq.size == keys.size
  end
end

def solve(input)
  count_valid(input, &:itself)
end

def solve2(input)
  count_valid(input) { |w| w.chars.sort.join }
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    aa bb cc dd ee
    aa bb cc dd aa
    aa bb cc dd aaa
  INPUT

  EXAMPLE2 = <<~INPUT
    abcde fghij
    abcde xyz ecdab
    a ab abc abd abf abj
    iiii oiii ooii oooi oooo
    oiii ioii iioi iiio
  INPUT

  def test_solve_example
    assert_equal 2, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 337, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 3, solve2(EXAMPLE2)
  end

  def test_solve2_input
    assert_equal 231, solve2(read_file('input.txt'))
  end
end
