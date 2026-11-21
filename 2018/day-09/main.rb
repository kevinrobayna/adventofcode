# frozen_string_literal: true

require_relative '../../lib/aoc'

def high_score(players, last)
  nxt = Array.new(last + 1, 0)
  prv = Array.new(last + 1, 0)
  scores = Array.new(players, 0)
  cur = 0
  (1..last).each do |m|
    if (m % 23).zero?
      6.times { cur = prv[cur] }
      victim = prv[cur]
      scores[m % players] += m + victim
      a = prv[victim]
      nxt[a] = cur
      prv[cur] = a
    else
      a = nxt[cur]
      b = nxt[a]
      nxt[a] = m
      prv[m] = a
      nxt[m] = b
      prv[b] = m
      cur = m
    end
  end
  scores.max
end

def solve(input, factor: 1)
  players, last = input.scan(/\d+/).map(&:to_i)
  high_score(players, last * factor)
end

def solve2(input)
  solve(input, factor: 100)
end

class AoCTest < Minitest::Test
  def test_solve_example
    assert_equal 32, high_score(9, 25)
    assert_equal 8317, solve('10 players; last marble is worth 1618 points')
    assert_equal 146_373, solve('13 players; last marble is worth 7999 points')
    assert_equal 2764, solve('17 players; last marble is worth 1104 points')
    assert_equal 54_718, solve('21 players; last marble is worth 6111 points')
    assert_equal 37_305, solve('30 players; last marble is worth 5807 points')
  end

  def test_solve_input
    assert_equal 404_611, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 3_350_093_681, solve2(read_file('input.txt'))
  end
end
