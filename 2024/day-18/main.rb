# frozen_string_literal: true

require_relative '../../lib/aoc'

def parse(input)
  input.lines.map { _1.split(',').map(&:to_i) }
end

# BFS from the top-left to the bottom-right corner; returns steps or nil when unreachable.
def shortest(walls, size)
  goal = [size, size]
  seen = Set[[0, 0]]
  frontier = [[0, 0]]
  steps = 0
  until frontier.empty?
    return steps if seen.include?(goal)

    steps += 1
    frontier = frontier.flat_map do |x, y|
      [[x + 1, y], [x - 1, y], [x, y + 1], [x, y - 1]].select do |nx, ny|
        nx.between?(0, size) && ny.between?(0, size) && !walls.include?([nx, ny]) && seen.add?([nx, ny])
      end
    end
  end
  seen.include?(goal) ? steps : nil
end

def solve(input, size: 70, bytes: 1024)
  shortest(parse(input).first(bytes).to_set, size)
end

# Binary search for the first prefix of falling bytes that cuts off the exit.
def solve2(input, size: 70)
  bytes = parse(input)
  index = (1..bytes.size).bsearch { |n| shortest(bytes.first(n).to_set, size).nil? }
  bytes[index - 1].join(',')
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    5,4
    4,2
    4,5
    3,0
    2,1
    6,3
    2,4
    1,5
    0,6
    3,3
    2,6
    5,1
    1,2
    5,5
    2,5
    6,5
    1,4
    0,4
    6,4
    1,1
    6,1
    1,0
    0,5
    1,6
    2,0
  INPUT

  def test_solve_example
    assert_equal 22, solve(EXAMPLE, size: 6, bytes: 12)
  end

  def test_solve2_example
    assert_equal '6,1', solve2(EXAMPLE, size: 6)
  end

  def test_solve_input
    assert_equal 286, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal '20,64', solve2(read_file('input.txt'))
  end
end
