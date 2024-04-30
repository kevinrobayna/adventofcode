# frozen_string_literal: true

require "pry"
require "colorize"

class Object
  def number?
    to_f.to_s == to_s || to_i.to_s == to_s
  end
end

def compare_solutions(expected, actual)
  raise "Expected #{expected} but got #{actual}" unless expected == actual

  puts "Congratulations! Got expected result (#{expected})"
end

def read_file(filename)
  # Get the directory of the currently executing script
  # Join the script directory with the filename
  # Read the content of the file
  File.read(File.join(__dir__, filename))
end

MOVEMENTS = [
  [-1, -1], [-1, 1],
  [1, -1], [1, 1],
  [0, -1], [0, 1],
  [-1, 0], [1, 0]
].freeze

def solve(filename)
  board = read_file(filename).lines.map { _1.strip.chars }
  numbers = possible_parts(board)

  valid_parts = numbers.select do |_number, positions|
    positions.any? do |inx_x, inx_y|
      MOVEMENTS.any? do |mov_x, mov_y|
        next_x = mov_x + inx_x
        next_y = mov_y + inx_y

        next if next_x.negative?
        next if next_y.negative?
        next if next_x >= board.length
        next if next_y >= board.first.length

        next_v = board[next_x][next_y]
        next if next_v == "." || next_v.number?

        true
      end
    end
  end

  valid_parts.map { |number, _| number }.sum
end

def solve2(filename)
  board = read_file(filename).lines.map { _1.strip.chars }
  numbers = possible_parts(board)

  potential_numbers = numbers.select do |_number, positions|
    positions.any? do |inx_x, inx_y|
      MOVEMENTS.any? do |mov_x, mov_y|
        next_x = mov_x + inx_x
        next_y = mov_y + inx_y

        next if next_x.negative?
        next if next_y.negative?
        next if next_x >= board.length
        next if next_y >= board.first.length

        next_v = board[next_x][next_y]
        next unless next_v == "*"

        true
      end
    end
  end

  valid_parts = []
  products = []
  board.each_with_index do |row, inx_x|
    row.each_with_index do |v, inx_y|
      next unless v == "*"

      neighbours = []
      MOVEMENTS.each do |mov_x, mov_y|
        next_x = mov_x + inx_x
        next_y = mov_y + inx_y

        selected = potential_numbers.select do |number, positions|
          positions.include?([next_x, next_y]) && !neighbours.include?([number, positions])
        end
        next if selected.empty?
        next if selected.length > 1

        neighbours << selected.first
      end

      next if neighbours.length == 1

      valid_parts << neighbours.first
      valid_parts << neighbours.last
      products << neighbours.first.first * neighbours.last.first
    end
  end

  debug_board(board, valid_parts)

  products.sum
end

def possible_parts(board)
  numbers = []
  board.each_with_index do |row, inx_x|
    number = []
    positions = []
    row.each_with_index do |v, inx_y|
      if v.number?
        number << v
        positions << [inx_x, inx_y]
      else
        numbers << [number.join.to_i, positions] unless number.empty?

        number = []
        positions = []
      end
    end
    numbers << [number.join.to_i, positions] unless number.empty?
  end
  numbers
end

def debug_board(board, valid_parts)
  board.each_with_index do |row, inx_x|
    row.each_with_index do |v, inx_y|
      board[inx_x][inx_y] = v.green if v != "." && v != "*" && !v.number?
      board[inx_x][inx_y] = v.red if v == "*"
    end
  end
  valid_parts.each_value do |positions|
    positions.each do |inx_x, inx_y|
      board[inx_x][inx_y] = board[inx_x][inx_y].yellow
    end
  end
  puts board.map(&:join).join("\n")
end

compare_solutions(4361, solve("test.txt"))
compare_solutions(4361, solve("test2.txt"))
compare_solutions(557_705, solve("input.txt"))
puts "Part1", solve("input.txt")

compare_solutions(467_835, solve2("test.txt"))
puts "Part2", solve2("input.txt")
