# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

# Josephus with k=2: the winner is 2 * (n - highest power of two <= n) + 1.
def solve(input)
  n = input.to_i
  (2 * (n - (1 << (n.bit_length - 1)))) + 1
end

# Stealing from across the circle: closed form in terms of the highest power of three <= n.
def solve2(input)
  n = input.to_i
  p = 1
  p *= 3 while p * 3 <= n
  return n if n == p

  n - p <= p ? n - p : (2 * n) - (3 * p)
end

def simulate(n, across:)
  elves = (1..n).to_a
  i = 0
  while elves.size > 1
    victim = across ? (i + (elves.size / 2)) % elves.size : (i + 1) % elves.size
    elves.delete_at(victim)
    i += 1 if victim > i
    i %= elves.size
  end
  elves.first
end

class AoCTest < Minitest::Test
  def test_solve_example
    assert_equal 3, solve('5')
    (1..100).each { |n| assert_equal simulate(n, across: false), solve(n.to_s) }
  end

  def test_solve_input
    assert_equal 1_830_117, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 2, solve2('5')
    (1..100).each { |n| assert_equal simulate(n, across: true), solve2(n.to_s) }
  end

  def test_solve2_input
    assert_equal 1_417_887, solve2(read_file('input.txt'))
  end
end
