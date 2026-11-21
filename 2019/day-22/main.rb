# frozen_string_literal: true

require_relative '../../lib/aoc'

# The whole shuffle as a linear map position -> (a * position + b) mod size.
def shuffle_map(input, size)
  input.lines.reduce([1, 0]) do |(a, b), line|
    n = line[/-?\d+/].to_i
    c, d = case line
           when /new stack/ then [-1, -1]
           when /cut/ then [1, -n]
           when /increment/ then [n, 0]
           end
    [(c * a) % size, ((c * b) + d) % size]
  end
end

def deck_after(input, size)
  a, b = shuffle_map(input, size)
  result = Array.new(size)
  size.times { result[((a * it) + b) % size] = it }
  result
end

def solve(input, size: 10_007, card: 2019)
  a, b = shuffle_map(input, size)
  ((a * card) + b) % size
end

# Composes the map `times` times (geometric series) and inverts it to find the card at `position`.
def solve2(input, size: 119_315_717_514_047, times: 101_741_582_076_661, position: 2020)
  a, b = shuffle_map(input, size)
  an = a.pow(times, size)
  bn = b * (an - 1) * (a - 1).pow(size - 2, size) % size
  (position - bn) * an.pow(size - 2, size) % size
end

class AoCTest < Minitest::Test
  def test_solve_example
    assert_equal [9, 8, 7, 6, 5, 4, 3, 2, 1, 0], deck_after('deal into new stack', 10)
    assert_equal [3, 4, 5, 6, 7, 8, 9, 0, 1, 2], deck_after('cut 3', 10)
    assert_equal [6, 7, 8, 9, 0, 1, 2, 3, 4, 5], deck_after('cut -4', 10)
    assert_equal [0, 7, 4, 1, 8, 5, 2, 9, 6, 3], deck_after('deal with increment 3', 10)
    assert_equal [0, 3, 6, 9, 2, 5, 8, 1, 4, 7], deck_after("deal with increment 7\ndeal into new stack\ndeal into new stack\n", 10)
    assert_equal [3, 0, 7, 4, 1, 8, 5, 2, 9, 6], deck_after("cut 6\ndeal with increment 7\ndeal into new stack\n", 10)
    assert_equal [6, 3, 0, 7, 4, 1, 8, 5, 2, 9], deck_after("deal with increment 7\ndeal with increment 9\ncut -2\n", 10)
    assert_equal [9, 2, 5, 8, 1, 4, 7, 0, 3, 6], deck_after(EXAMPLE, 10)
  end

  EXAMPLE = <<~INPUT
    deal into new stack
    cut -2
    deal with increment 7
    cut 8
    cut -4
    deal with increment 7
    cut 3
    deal with increment 9
    deal with increment 3
    cut -1
  INPUT

  def test_solve_input
    assert_equal 8191, solve(read_file('input.txt'))
  end

  def test_solve2_example
    # Brute force on a small prime-sized deck: repeat the shuffle and read the card at a position.
    deck = (0...11).to_a
    3.times { deck = deck_after(EXAMPLE, 11).map { deck[it] } }

    assert_equal deck[5], solve2(EXAMPLE, size: 11, times: 3, position: 5)
  end

  def test_solve2_input
    assert_equal 1_644_352_419_829, solve2(read_file('input.txt'))
  end
end
