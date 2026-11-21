# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

# Number of winning numbers per card.
def parse(input)
  input.each_line.map do |line|
    _, numbers = line.split(':')
    left, right = numbers.split('|')
    (left.split & right.split).length
  end
end

def solve(input)
  parse(input).sum { |matches| matches.zero? ? 0 : 2**(matches - 1) }
end

def solve2(input)
  matches = parse(input)
  copies = Array.new(matches.length, 1)
  matches.each_with_index do |count, inx|
    (1..count).each { |x| copies[inx + x] += copies[inx] if inx + x < copies.length }
  end
  copies.sum
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
    Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
    Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
    Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
    Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
    Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
  INPUT

  def test_solve_example
    assert_equal 13, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 25_231, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 30, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 9_721_255, solve2(read_file('input.txt'))
  end
end
