# frozen_string_literal: true

require_relative '../../lib/aoc'

# Drops all bricks and returns [supported_by, supports] as arrays of Sets indexed by brick.
def settle(input)
  bricks = input.lines.map { it.scan(/\d+/).map(&:to_i) }.sort_by { [it[2], it[5]].min }
  heights = Hash.new([0, nil]) # [x, y] => [top z, brick index]
  supported_by = Array.new(bricks.size) { Set.new }
  supports = Array.new(bricks.size) { Set.new }

  bricks.each_with_index do |(x1, y1, z1, x2, y2, z2), i|
    cells = Range.new(*[x1, x2].minmax).to_a.product(Range.new(*[y1, y2].minmax).to_a)
    base = cells.map { heights[it][0] }.max
    cells.each do |cell|
      top, below = heights[cell]
      if top == base && below
        supported_by[i] << below
        supports[below] << i
      end
    end
    new_top = base + (z1 - z2).abs + 1
    cells.each { heights[it] = [new_top, i] }
  end
  [supported_by, supports]
end

def solve(input)
  supported_by, supports = settle(input)
  supports.count { |above| above.all? { supported_by[it].size > 1 } }
end

def solve2(input)
  supported_by, supports = settle(input)
  supports.each_index.sum do |start|
    fallen = Set[start]
    queue = supports[start].to_a
    until queue.empty?
      brick = queue.shift
      next if fallen.include?(brick) || !supported_by[brick].subset?(fallen)

      fallen << brick
      queue.concat(supports[brick].to_a)
    end
    fallen.size - 1
  end
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    1,0,1~1,2,1
    0,0,2~2,0,2
    0,2,3~2,2,3
    0,0,4~0,2,4
    2,0,5~2,2,5
    0,1,6~2,1,6
    1,1,8~1,1,9
  INPUT

  def test_solve_example
    assert_equal 5, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 482, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 7, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 103_010, solve2(read_file('input.txt'))
  end
end
