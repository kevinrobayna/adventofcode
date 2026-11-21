# frozen_string_literal: true

require_relative '../../lib/aoc'

def walk(input)
  pos = Complex(0, 0)
  dir = Complex(0, 1)
  path = []
  input.strip.split(', ').each do |step|
    dir *= step[0] == 'R' ? Complex(0, -1) : Complex(0, 1)
    step[1..].to_i.times do
      pos += dir
      path << pos
    end
  end
  path
end

def distance(pos) = pos.real.abs + pos.imaginary.abs

def solve(input)
  distance(walk(input).last)
end

def solve2(input)
  seen = Set.new
  distance(walk(input).find { |pos| !seen.add?(pos) })
end

class AoCTest < Minitest::Test
  def test_solve_example
    assert_equal 5, solve('R2, L3')
    assert_equal 2, solve('R2, R2, R2')
    assert_equal 12, solve('R5, L5, R5, R3')
  end

  def test_solve_input
    assert_equal 230, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 4, solve2('R8, R4, R4, R8')
  end

  def test_solve2_input
    assert_equal 154, solve2(read_file('input.txt'))
  end
end
