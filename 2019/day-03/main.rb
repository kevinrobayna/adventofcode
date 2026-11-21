# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

DIRS = { 'R' => [1, 0], 'L' => [-1, 0], 'U' => [0, 1], 'D' => [0, -1] }.freeze

# Maps each visited point to the number of steps first needed to reach it.
def trace(wire)
  x = y = steps = 0
  seen = {}
  wire.split(',').each do |move|
    dx, dy = DIRS.fetch(move[0])
    move[1..].to_i.times do
      x += dx
      y += dy
      steps += 1
      seen[[x, y]] ||= steps
    end
  end
  seen
end

def crossings(input)
  a, b = input.split.map { trace(it) }
  [a, b, a.keys & b.keys]
end

def solve(input)
  _, _, common = crossings(input)
  common.map { |x, y| x.abs + y.abs }.min
end

def solve2(input)
  a, b, common = crossings(input)
  common.map { a[it] + b[it] }.min
end

class AoCTest < Minitest::Test
  EXAMPLE = "R8,U5,L5,D3\nU7,R6,D4,L4\n"
  EXAMPLE2 = "R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83\n"
  EXAMPLE3 = "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7\n"

  def test_solve_example
    assert_equal 6, solve(EXAMPLE)
    assert_equal 159, solve(EXAMPLE2)
    assert_equal 135, solve(EXAMPLE3)
  end

  def test_solve2_example
    assert_equal 30, solve2(EXAMPLE)
    assert_equal 610, solve2(EXAMPLE2)
    assert_equal 410, solve2(EXAMPLE3)
  end

  def test_solve_input
    assert_equal 1983, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 107_754, solve2(read_file('input.txt'))
  end
end
