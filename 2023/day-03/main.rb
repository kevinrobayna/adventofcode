# frozen_string_literal: true

require 'pry'
require 'colorize'

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
  numbers = []
  board = read_file(filename).lines.map { _1.strip.chars }
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
  end
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
        next if next_v == '.' || next_v.number?

        true
      end
    end
  end

  board.each_with_index do |row, inx_x|
    row.each_with_index do |v, inx_y|
      board[inx_x][inx_y] = v.red if v != '.' && !v.number?
    end
  end
  valid_parts.each do |_number, positions|
    positions.each do |inx_x, inx_y|
      board[inx_x][inx_y] = board[inx_x][inx_y].yellow
    end
  end
  puts board.map(&:join).join("\n")
  valid_parts.map { |number, _| number }.sum
end

def solve2(filename)
  read_file(filename)
  0
end

compare_solutions(4361, solve('test.txt'))
compare_solutions(4361, solve('test2.txt'))
compare_solutions(557_705, solve('input.txt'))
puts 'Part1', solve('input.txt')

compare_solutions(0, solve2('test.txt'))
puts 'Part2', solve2('input.txt')
