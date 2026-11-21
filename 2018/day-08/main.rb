# frozen_string_literal: true

require_relative '../../lib/aoc'

Node = Struct.new(:children, :metadata) do
  def checksum
    metadata.sum + children.sum(&:checksum)
  end

  def value
    return metadata.sum if children.empty?

    metadata.sum { |m| m.positive? && children[m - 1] ? children[m - 1].value : 0 }
  end
end

def parse_node(nums)
  child_count = nums.shift
  meta_count = nums.shift
  children = Array.new(child_count) { parse_node(nums) }
  Node.new(children, nums.shift(meta_count))
end

def tree(input)
  parse_node(input.split.map(&:to_i))
end

def solve(input)
  tree(input).checksum
end

def solve2(input)
  tree(input).value
end

class AoCTest < Minitest::Test
  EXAMPLE = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2\n"

  def test_solve_example
    assert_equal 138, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 44_893, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 66, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 27_433, solve2(read_file('input.txt'))
  end
end
