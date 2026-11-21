# frozen_string_literal: true

require_relative '../../lib/aoc'

def pipe_groups(input)
  graph = input.lines.to_h do |line|
    id, rest = line.split(' <-> ')
    [id.to_i, rest.split(',').map(&:to_i)]
  end
  unseen = graph.keys.to_set
  groups = []
  until unseen.empty?
    start = unseen.first
    group = Set[start]
    stack = [start]
    graph[stack.pop].each { |n| stack << n if group.add?(n) } until stack.empty?
    unseen -= group
    groups << group
  end
  groups
end

def solve(input)
  pipe_groups(input).find { |g| g.include?(0) }.size
end

def solve2(input)
  pipe_groups(input).size
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    0 <-> 2
    1 <-> 1
    2 <-> 0, 3, 4
    3 <-> 2, 4
    4 <-> 2, 3, 6
    5 <-> 6
    6 <-> 4, 5
  INPUT

  def test_solve_example
    assert_equal 6, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 134, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 2, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 193, solve2(read_file('input.txt'))
  end
end
