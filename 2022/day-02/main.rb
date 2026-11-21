# frozen_string_literal: true

require_relative '../../lib/aoc'

ROCK = 0
PAPER = 1
SCISSORS = 2

WIN = 6
LOSE = 0
DRAW = 3

TRANSLATION = {
  'A' => 0, 'X' => 0,
  'B' => 1, 'Y' => 1,
  'C' => 2, 'Z' => 2
}.freeze

POINTS = [
  [DRAW, WIN, LOSE],
  [LOSE, DRAW, WIN],
  [WIN, LOSE, DRAW]
].freeze

CHEAT = [
  # ROCK PAPER SCISSORS
  [SCISSORS, ROCK, PAPER], # LOSE
  [ROCK, PAPER, SCISSORS], # DRAW
  [PAPER, SCISSORS, ROCK] # WIN
].freeze

def rounds(input)
  input.split("\n").map { |line| line.split.map { |c| TRANSLATION[c] } }
end

def solve(input)
  rounds(input).sum { |opponent, yours| POINTS[opponent][yours] + yours + 1 }
end

def solve2(input)
  rounds(input).sum do |opponent, outcome|
    yours = CHEAT[outcome][opponent]
    POINTS[opponent][yours] + yours + 1
  end
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    A Y
    B X
    C Z
  INPUT

  def test_solve_example
    assert_equal 15, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 15_632, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 12, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 14_416, solve2(read_file('input.txt'))
  end
end
