# frozen_string_literal: true

require_relative '../../lib/aoc'

def decks(input)
  input.split("\n\n").map { |block| block.lines.drop(1).map(&:to_i) }
end

def score(deck)
  deck.reverse.each_with_index.sum { |card, i| card * (i + 1) }
end

def solve(input)
  a, b = decks(input)
  until a.empty? || b.empty?
    x = a.shift
    y = b.shift
    x > y ? a.push(x, y) : b.push(y, x)
  end
  score(a.empty? ? b : a)
end

# Returns [winner (1 or 2), winner's deck].
def recursive_combat(a, b)
  seen = Set.new
  until a.empty? || b.empty?
    return [1, a] unless seen.add?([a, b].hash)

    x = a.shift
    y = b.shift
    winner = if a.size >= x && b.size >= y
               recursive_combat(a.first(x), b.first(y)).first
             else
               x > y ? 1 : 2
             end
    winner == 1 ? a.push(x, y) : b.push(y, x)
  end
  a.empty? ? [2, b] : [1, a]
end

def solve2(input)
  score(recursive_combat(*decks(input)).last)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    Player 1:
    9
    2
    6
    3
    1

    Player 2:
    5
    8
    4
    7
    10
  INPUT

  def test_solve_example
    assert_equal 306, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 33_631, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 291, solve2(EXAMPLE)
    assert_equal 105, solve2("Player 1:\n43\n19\n\nPlayer 2:\n2\n29\n14\n") # terminates via loop rule
  end

  def test_solve2_input
    assert_equal 33_469, solve2(read_file('input.txt'))
  end
end
