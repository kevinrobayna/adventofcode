# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

MOVEMENTS = [
  [-1, -1], [-1, 1],
  [1, -1], [1, 1],
  [0, -1], [0, 1],
  [-1, 0], [1, 0]
].freeze

# Returns [[number, [[x, y], ...]], ...] for every number on the board.
def possible_parts(board)
  numbers = []
  board.each_with_index do |row, x|
    row.join.scan(/\d+/) do
      start = Regexp.last_match.begin(0)
      numbers << [Regexp.last_match(0).to_i, (start...Regexp.last_match.end(0)).map { |y| [x, y] }]
    end
  end
  numbers
end

def neighbours(board, positions)
  positions.flat_map do |x, y|
    MOVEMENTS.filter_map do |dx, dy|
      nx = x + dx
      ny = y + dy
      next if nx.negative? || ny.negative? || nx >= board.length || ny >= board.first.length

      [nx, ny]
    end
  end.uniq
end

def solve(input)
  board = input.lines.map { it.strip.chars }
  possible_parts(board).sum do |number, positions|
    symbol = neighbours(board, positions).any? { |x, y| board[x][y].match?(/[^.\d]/) }
    symbol ? number : 0
  end
end

def solve2(input)
  board = input.lines.map { it.strip.chars }
  gears = Hash.new { |h, k| h[k] = [] }
  possible_parts(board).each do |number, positions|
    neighbours(board, positions).each { |x, y| gears[[x, y]] << number if board[x][y] == '*' }
  end
  gears.values.select { it.length == 2 }.sum { |a, b| a * b }
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    467..114..
    ...*......
    ..35..633.
    ......#...
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598..
  INPUT

  EXAMPLE2 = <<~INPUT
    467..114..
    ...*......
    ..35...633
    .......#..
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598..
  INPUT

  def test_solve_example
    assert_equal 4361, solve(EXAMPLE)
    assert_equal 4361, solve(EXAMPLE2)
  end

  def test_solve_input
    assert_equal 557_705, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 467_835, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 84_266_818, solve2(read_file('input.txt'))
  end
end
