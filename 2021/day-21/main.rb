# frozen_string_literal: true

require_relative '../../lib/aoc'

def parse(input)
  input.scan(/position: (\d+)/).flatten.map(&:to_i)
end

def solve(input)
  positions = parse(input)
  scores = [0, 0]
  rolls = 0
  player = 0
  loop do
    move = (1..3).sum { |i| ((rolls + i - 1) % 100) + 1 }
    rolls += 3
    positions[player] = ((positions[player] + move - 1) % 10) + 1
    scores[player] += positions[player]
    return scores[1 - player] * rolls if scores[player] >= 1000

    player = 1 - player
  end
end

# How many universes produce each sum of three Dirac dice rolls.
DIRAC_SUMS = [1, 2, 3].product([1, 2, 3], [1, 2, 3]).map(&:sum).tally.freeze

# Returns [wins for player to move, wins for the other player].
def count_wins(pos, other_pos, score, other_score, memo)
  memo[[pos, other_pos, score, other_score]] ||= begin
    wins = [0, 0]
    DIRAC_SUMS.each do |move, universes|
      new_pos = ((pos + move - 1) % 10) + 1
      new_score = score + new_pos
      if new_score >= 21
        wins[0] += universes
      else
        other_wins, my_wins = count_wins(other_pos, new_pos, other_score, new_score, memo)
        wins[0] += my_wins * universes
        wins[1] += other_wins * universes
      end
    end
    wins
  end
end

def solve2(input)
  p1, p2 = parse(input)
  count_wins(p1, p2, 0, 0, {}).max
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    Player 1 starting position: 4
    Player 2 starting position: 8
  INPUT

  def test_solve_example
    assert_equal 739_785, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 897_798, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 444_356_092_776_315, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 48_868_319_769_358, solve2(read_file('input.txt'))
  end
end
