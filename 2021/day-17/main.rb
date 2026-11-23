# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

# Returns all initial velocities whose trajectory hits the target area (assumes target below and right of origin).
def hitting_velocities(input)
  x1, x2, y1, y2 = input.scan(/-?\d+/).map(&:to_i)
  (1..x2).flat_map do |vx0|
    (y1..-y1).select do |vy0|
      x = y = 0
      vx = vx0
      vy = vy0
      hit = false
      while x <= x2 && y >= y1
        x += vx
        y += vy
        vx -= 1 if vx.positive?
        vy -= 1
        if x.between?(x1, x2) && y.between?(y1, y2)
          hit = true
          break
        end
      end
      hit
    end.map { |vy0| [vx0, vy0] }
  end
end

def solve(input)
  vy = hitting_velocities(input).map(&:last).max
  vy * (vy + 1) / 2
end

def solve2(input)
  hitting_velocities(input).size
end

class AoCTest < Minitest::Test
  EXAMPLE = "target area: x=20..30, y=-10..-5\n"

  def test_solve_example
    assert_equal 45, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 10_011, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 112, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 2994, solve2(read_file('input.txt'))
  end
end
