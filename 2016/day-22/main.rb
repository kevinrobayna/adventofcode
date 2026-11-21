# frozen_string_literal: true

require_relative '../../lib/aoc'

Node = Struct.new(:x, :y, :capacity, :used) do
  def avail = capacity - used
end

def parse(input)
  input.scan(/node-x(\d+)-y(\d+)\s+(\d+)T\s+(\d+)T/).map { |n| Node.new(*n.map(&:to_i)) }
end

def solve(input)
  nodes = parse(input)
  nodes.permutation(2).count { |a, b| a.used.positive? && a.used <= b.avail }
end

# BFS over (empty node, goal data) positions. Nodes whose data can't fit in the empty node are walls.
def solve2(input)
  nodes = parse(input)
  width = nodes.map(&:x).max + 1
  height = nodes.map(&:y).max + 1
  empty = nodes.find { |n| n.used.zero? }
  open = Set.new(nodes.select { |n| n.used <= empty.capacity }.map { |n| [n.x, n.y] })

  start = [[empty.x, empty.y], [width - 1, 0]]
  seen = Set[start]
  frontier = [start]
  steps = 0
  until frontier.empty?
    return steps if frontier.any? { |_, goal| goal == [0, 0] }

    steps += 1
    frontier = frontier.flat_map do |(ex, ey), goal|
      [[ex + 1, ey], [ex - 1, ey], [ex, ey + 1], [ex, ey - 1]].filter_map do |pos|
        next unless open.include?(pos) && pos[0] < width && pos[1] < height

        state = [pos, pos == goal ? [ex, ey] : goal]
        state if seen.add?(state)
      end
    end
  end
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    Filesystem            Size  Used  Avail  Use%
    /dev/grid/node-x0-y0   10T    8T     2T   80%
    /dev/grid/node-x0-y1   11T    6T     5T   54%
    /dev/grid/node-x0-y2   32T   28T     4T   87%
    /dev/grid/node-x1-y0    9T    7T     2T   77%
    /dev/grid/node-x1-y1    8T    0T     8T    0%
    /dev/grid/node-x1-y2   11T    7T     4T   63%
    /dev/grid/node-x2-y0   10T    6T     4T   60%
    /dev/grid/node-x2-y1    9T    8T     1T   88%
    /dev/grid/node-x2-y2    9T    6T     3T   66%
  INPUT

  def test_solve_example
    assert_equal 7, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 892, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 7, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 227, solve2(read_file('input.txt'))
  end
end
