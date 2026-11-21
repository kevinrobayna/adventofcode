# frozen_string_literal: true

require_relative '../../lib/aoc'

# nxt[c] is the cup clockwise of cup c.
def play(cups, moves)
  nxt = Array.new(cups.size + 1)
  cups.each_cons(2) { |a, b| nxt[a] = b }
  nxt[cups.last] = cups.first
  max = cups.size
  current = cups.first
  moves.times do
    p1 = nxt[current]
    p2 = nxt[p1]
    p3 = nxt[p2]
    nxt[current] = nxt[p3]
    dest = current
    loop do
      dest = dest == 1 ? max : dest - 1
      break unless dest == p1 || dest == p2 || dest == p3
    end
    nxt[p3] = nxt[dest]
    nxt[dest] = p1
    current = nxt[current]
  end
  nxt
end

def solve(input, moves: 100)
  nxt = play(input.strip.chars.map(&:to_i), moves)
  order = []
  cup = nxt[1]
  until cup == 1
    order << cup
    cup = nxt[cup]
  end
  order.join
end

def solve2(input)
  labels = input.strip.chars.map(&:to_i)
  nxt = play(labels + ((labels.size + 1)..1_000_000).to_a, 10_000_000)
  nxt[1] * nxt[nxt[1]]
end

class AoCTest < Minitest::Test
  EXAMPLE = '389125467'

  def test_solve_example
    assert_equal '92658374', solve(EXAMPLE, moves: 10)
    assert_equal '67384529', solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal '25368479', solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 149_245_887_792, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 44_541_319_250, solve2(read_file('input.txt'))
  end
end
