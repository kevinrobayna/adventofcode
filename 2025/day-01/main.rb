# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def rotations(input)
  input.split.map { |line| [line[0] == 'L' ? -1 : 1, line[1..].to_i] }
end

def solve(input)
  pos = 50
  rotations(input).count do |dir, dist|
    pos = (pos + (dir * dist)) % 100
    pos.zero?
  end
end

def zero_clicks(pos, dir, dist)
  return (pos + dist) / 100 if dir.positive?
  return dist / 100 if pos.zero?

  dist < pos ? 0 : ((dist - pos) / 100) + 1
end

def solve2(input)
  pos = 50
  rotations(input).sum do |dir, dist|
    clicks = zero_clicks(pos, dir, dist)
    pos = (pos + (dir * dist)) % 100
    clicks
  end
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    L68
    L30
    R48
    L5
    R60
    L55
    L1
    L99
    R14
    L82
  INPUT

  def test_solve_example
    assert_equal 3, solve(EXAMPLE)
  end

  def test_solve2_example
    assert_equal 6, solve2(EXAMPLE)
  end

  def test_solve2_full_turns
    assert_equal 10, solve2("R1000\n")
    assert_equal 1, solve2("L50\n")
    assert_equal 2, solve2("L50\nL100\n")
    assert_equal 1, solve2("L50\nR99\n")
  end

  def test_solve_input
    assert_equal 1055, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 6386, solve2(read_file('input.txt'))
  end
end
