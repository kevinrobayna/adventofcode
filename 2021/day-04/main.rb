# frozen_string_literal: true

require_relative '../../lib/aoc'

def parse(input)
  numbers, *boards = input.split("\n\n")
  [numbers.split(',').map(&:to_i), boards.map { |b| b.split("\n").map { |row| row.split.map(&:to_i) } }]
end

def winner?(board, drawn)
  board.any? { |row| row.all? { |n| drawn.include?(n) } } ||
    board.transpose.any? { |col| col.all? { |n| drawn.include?(n) } }
end

# Returns the scores of the boards in the order they win.
def winning_scores(input)
  numbers, boards = parse(input)
  drawn = Set.new
  scores = []
  numbers.each do |number|
    drawn << number
    winners, boards = boards.partition { |board| winner?(board, drawn) }
    winners.each { |board| scores << (board.flatten.reject { |n| drawn.include?(n) }.sum * number) }
  end
  scores
end

def solve(input)
  winning_scores(input).first
end

def solve2(input)
  winning_scores(input).last
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

    22 13 17 11  0
     8  2 23  4 24
    21  9 14 16  7
     6 10  3 18  5
     1 12 20 15 19

     3 15  0  2 22
     9 18 13 17  5
    19  8  7 25 23
    20 11 10 24  4
    14 21 16 12  6

    14 21 17 24  4
    10 16 15  9 19
    18  8 23 26 20
    22 11 13  6  5
     2  0 12  3  7
  INPUT

  def test_solve_example
    assert_equal 4512, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 35_711, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 1924, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 5586, solve2(read_file('input.txt'))
  end
end
