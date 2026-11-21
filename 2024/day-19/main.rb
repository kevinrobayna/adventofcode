# frozen_string_literal: true

require_relative '../../lib/aoc'

def parse(input)
  patterns, designs = input.split("\n\n")
  [patterns.strip.split(', ').to_set, designs.lines.map(&:strip)]
end

# Counts the ways to build `design` from towel patterns with a prefix DP.
def arrangements(design, patterns)
  ways = Array.new(design.size + 1, 0)
  ways[0] = 1
  longest = patterns.map(&:size).max
  (0...design.size).each do |i|
    next if ways[i].zero?

    (1..[longest, design.size - i].min).each do |len|
      ways[i + len] += ways[i] if patterns.include?(design[i, len])
    end
  end
  ways[design.size]
end

def solve(input)
  patterns, designs = parse(input)
  designs.count { arrangements(_1, patterns).positive? }
end

def solve2(input)
  patterns, designs = parse(input)
  designs.sum { arrangements(_1, patterns) }
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    r, wr, b, g, bwu, rb, gb, br

    brwrr
    bggr
    gbbr
    rrbgbr
    ubwu
    bwurrg
    brgr
    bbrgwb
  INPUT

  def test_solve_example
    assert_equal 6, solve(EXAMPLE)
  end

  def test_solve2_example
    assert_equal 16, solve2(EXAMPLE)
  end

  def test_solve_input
    assert_equal 236, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 643_685_981_770_598, solve2(read_file('input.txt'))
  end
end
