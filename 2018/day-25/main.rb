# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def solve(input)
  points = input.lines.map { |l| l.scan(/-?\d+/).map(&:to_i) }.reject(&:empty?)
  parent = (0...points.size).to_a
  find = ->(i) { parent[i] == i ? i : (parent[i] = find.call(parent[i])) }
  points.each_with_index.to_a.combination(2) do |(a, i), (b, j)|
    parent[find.call(i)] = find.call(j) if a.zip(b).sum { |p, q| (p - q).abs } <= 3
  end
  points.each_index.map { |i| find.call(i) }.uniq.size
end

class AoCTest < Minitest::Test
  EXAMPLES = {
    2 => <<~INPUT,
      0,0,0,0
      3,0,0,0
      0,3,0,0
      0,0,3,0
      0,0,0,3
      0,0,0,6
      9,0,0,0
      12,0,0,0
    INPUT
    4 => <<~INPUT,
      -1,2,2,0
      0,0,2,-2
      0,0,0,-2
      -1,2,0,0
      -2,-2,-2,2
      3,0,2,-1
      -1,3,2,2
      -1,0,-1,0
      0,2,1,-2
      3,0,0,0
    INPUT
    3 => <<~INPUT,
      1,-1,0,1
      2,0,-1,0
      3,2,-1,0
      0,0,3,1
      0,0,-1,-1
      2,3,-2,0
      -2,2,0,0
      2,-2,0,-1
      1,-1,0,-1
      3,2,0,2
    INPUT
    8 => <<~INPUT
      1,-1,-1,-2
      -2,-2,0,1
      0,2,1,3
      -2,3,-2,1
      0,2,3,-2
      -1,-1,1,-2
      0,-2,-1,0
      -2,2,3,-1
      1,2,2,0
      -1,-2,0,-2
    INPUT
  }.freeze

  def test_solve_example
    EXAMPLES.each { |expected, input| assert_equal expected, solve(input) }
  end

  def test_solve_input
    assert_equal 399, solve(read_file('input.txt'))
  end
end
