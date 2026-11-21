# frozen_string_literal: true

require_relative '../../lib/aoc'

HEADINGS = { 'N' => Complex(0, 1), 'S' => Complex(0, -1), 'E' => Complex(1, 0), 'W' => Complex(-1, 0) }.freeze

def instructions(input)
  input.split.map { |l| [l[0], l[1..].to_i] }
end

def turn(action, value)
  Complex(0, action == 'L' ? 1 : -1)**(value / 90)
end

def manhattan(z)
  z.real.abs + z.imaginary.abs
end

def solve(input)
  pos = Complex(0, 0)
  dir = Complex(1, 0)
  instructions(input).each do |action, value|
    case action
    when 'L', 'R' then dir *= turn(action, value)
    when 'F' then pos += dir * value
    else pos += HEADINGS[action] * value
    end
  end
  manhattan(pos)
end

def solve2(input)
  pos = Complex(0, 0)
  waypoint = Complex(10, 1)
  instructions(input).each do |action, value|
    case action
    when 'L', 'R' then waypoint *= turn(action, value)
    when 'F' then pos += waypoint * value
    else waypoint += HEADINGS[action] * value
    end
  end
  manhattan(pos)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    F10
    N3
    F7
    R90
    F11
  INPUT

  def test_solve_example
    assert_equal 25, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 590, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 286, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 42_013, solve2(read_file('input.txt'))
  end
end
