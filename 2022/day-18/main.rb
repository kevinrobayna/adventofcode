# frozen_string_literal: true

require_relative '../../lib/aoc'

DIRECTIONS = [[1, 0, 0], [-1, 0, 0], [0, 1, 0], [0, -1, 0], [0, 0, 1], [0, 0, -1]].freeze

def parse_cubes(input)
  input.each_line.to_set { |line| line.split(',').map(&:to_i) }
end

def neighbors(cube)
  DIRECTIONS.map { |d| cube.zip(d).map(&:sum) }
end

def solve(input)
  cubes = parse_cubes(input)
  cubes.sum { |c| neighbors(c).count { |n| !cubes.include?(n) } }
end

# Flood-fill the air around the droplet within a bounding box one unit larger than it,
# counting every cube face the water touches.
def solve2(input)
  cubes = parse_cubes(input)
  lo, hi = cubes.to_a.flatten.minmax
  lo -= 1
  hi += 1
  start = [lo, lo, lo]
  seen = Set[start]
  queue = [start]
  faces = 0
  until queue.empty?
    neighbors(queue.shift).each do |n|
      next unless n.all? { |v| v.between?(lo, hi) }

      if cubes.include?(n)
        faces += 1
      elsif seen.add?(n)
        queue << n
      end
    end
  end
  faces
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    2,2,2
    1,2,2
    3,2,2
    2,1,2
    2,3,2
    2,2,1
    2,2,3
    2,2,4
    2,2,6
    1,2,5
    3,2,5
    2,1,5
    2,3,5
  INPUT

  def test_solve_example
    assert_equal 10, solve("1,1,1\n2,1,1\n")
    assert_equal 64, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 3530, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 58, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 2000, solve2(read_file('input.txt'))
  end
end
