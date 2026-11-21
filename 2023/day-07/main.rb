# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

TYPES = [
  [1, 1, 1, 1, 1],
  [2, 1, 1, 1],
  [2, 2, 1],
  [3, 1, 1],
  [3, 2],
  [4, 1],
  [5]
].freeze

RANK = '23456789TJQKA'

def type_index(hand)
  TYPES.index(hand.chars.tally.values.sort.reverse)
end

def calculate_solution(input, joker: false)
  ranks = joker ? "J#{RANK.delete('J')}" : RANK
  input.each_line.map do |line|
    hand, bid = line.split
    [hand, bid.to_i]
  end.sort_by do |hand, _bid|
    options = Set[hand]
    hand.chars.uniq.each { |card| options << hand.gsub('J', card) } if joker && hand.include?('J')
    [options.map { type_index(it) }.max, *hand.chars.map { ranks.index(it) }]
  end.each_with_index.sum { |(_hand, bid), inx| (inx + 1) * bid }
end

def solve(input)
  calculate_solution(input)
end

def solve2(input)
  calculate_solution(input, joker: true)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    32T3K 765
    T55J5 684
    KK677 28
    KTJJT 220
    QQQJA 483
  INPUT

  def test_solve_example
    assert_equal 6440, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 247_961_593, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 5905, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 248_750_699, solve2(read_file('input.txt'))
  end
end
