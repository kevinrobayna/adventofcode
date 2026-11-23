# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def play(input, turns)
  starting = input.split(',').map(&:to_i)
  last_seen = Array.new(turns, 0) # turn (1-based) when a number was last spoken, 0 = never
  starting[0...-1].each_with_index { |n, i| last_seen[n] = i + 1 }
  current = starting.last
  turn = starting.size
  while turn < turns
    prev = last_seen[current]
    last_seen[current] = turn
    current = prev.zero? ? 0 : turn - prev
    turn += 1
  end
  current
end

def solve(input)
  play(input, 2020)
end

def solve2(input)
  play(input, 30_000_000)
end

class AoCTest < Minitest::Test
  def test_solve_example
    assert_equal 436, solve('0,3,6')
    assert_equal 1, solve('1,3,2')
    assert_equal 10, solve('2,1,3')
    assert_equal 27, solve('1,2,3')
    assert_equal 78, solve('2,3,1')
    assert_equal 438, solve('3,2,1')
    assert_equal 1836, solve('3,1,2')
  end

  def test_solve_input
    assert_equal 1009, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 175_594, solve2('0,3,6')
  end

  def test_solve2_input
    assert_equal 62_714, solve2(read_file('input.txt'))
  end
end
