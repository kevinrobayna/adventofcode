# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def parse(input)
  input.split("\n\n").map { |block| block.lines.map { it.strip.chars } }
end

# Index of the row above which the pattern mirrors with exactly `smudges` differing cells (0 if none).
def mirror_row(pattern, smudges)
  (1...pattern.length).find do |row|
    above = pattern[0...row].reverse
    below = pattern[row..]
    above.zip(below).sum { |a, b| b ? a.zip(b).count { |x, y| x != y } : 0 } == smudges
  end || 0
end

def summarize(input, smudges)
  parse(input).sum do |pattern|
    (100 * mirror_row(pattern, smudges)) + mirror_row(pattern.transpose, smudges)
  end
end

def solve(input)
  summarize(input, 0)
end

def solve2(input)
  summarize(input, 1)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    #.##..##.
    ..#.##.#.
    ##......#
    ##......#
    ..#.##.#.
    ..##..##.
    #.#.##.#.

    #...##..#
    #....#..#
    ..##..###
    #####.##.
    #####.##.
    ..##..###
    #....#..#
  INPUT

  def test_solve_example
    assert_equal 405, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 33_520, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 400, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 34_824, solve2(read_file('input.txt'))
  end
end
