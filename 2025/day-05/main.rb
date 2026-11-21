# frozen_string_literal: true

require_relative '../../lib/aoc'

def parse(input)
  ranges, ids = input.split("\n\n")
  [ranges.split.map { |r| Range.new(*r.split('-').map(&:to_i)) }, ids.split.map(&:to_i)]
end

def solve(input)
  ranges, ids = parse(input)
  ids.count { |id| ranges.any? { |r| r.cover?(id) } }
end

def solve2(input)
  ranges, = parse(input)
  merged = ranges.sort_by(&:begin).each_with_object([]) do |r, acc|
    if acc.any? && r.begin <= acc.last.end + 1
      acc[-1] = acc.last.begin..[acc.last.end, r.end].max
    else
      acc << r
    end
  end
  merged.sum(&:size)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    3-5
    10-14
    16-20
    12-18

    1
    5
    8
    11
    17
    32
  INPUT

  def test_solve_example
    assert_equal 3, solve(EXAMPLE)
  end

  def test_solve2_example
    assert_equal 14, solve2(EXAMPLE)
  end

  def test_solve2_nested_and_adjacent
    assert_equal 10, solve2("1-10\n2-3\n4-5\n\n1\n")
  end

  def test_solve_input
    assert_equal 828, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 352_681_648_086_146, solve2(read_file('input.txt'))
  end
end
