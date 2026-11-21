# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

ALPHABET = ('a'..'z').to_a + ('A'..'Z').to_a

def priority(char)
  ALPHABET.index(char) + 1
end

def common_char(strings)
  strings.map(&:chars).reduce(:&).first
end

def solve(input)
  input.split("\n").sum do |line|
    half = line.length / 2
    priority(common_char([line[0, half], line[half..]]))
  end
end

def solve2(input)
  input.split("\n").each_slice(3).sum { |group| priority(common_char(group)) }
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    vJrwpWtwJgWrhcsFMMfFFhFp
    jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
    PmmdzqPrVvPwwTWBwg
    wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
    ttgJtRGJQctTZtZT
    CrZsJsPPZsGzwwsLwLmpwMDw
  INPUT

  def test_solve_example
    assert_equal 157, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 8298, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 70, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 2708, solve2(read_file('input.txt'))
  end
end
