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
    numbers << [number.join.to_i, positions] unless number.empty?
  end

  puts "Parts To check: #{numbers.map { _1[0] }.join(', ')}"
  valid_parts = numbers.select do |_number, positions|
    puts "Checking number: #{_number.to_s.yellow}"
    x = positions.any? do |inx_x, inx_y|
      y = MOVEMENTS.any? do |mov_x, mov_y|
        puts "number: #{_number.to_s.yellow} (#{mov_x},#{mov_y})"
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

      puts "number: #{_number.to_s.green} (#{inx_x},#{inx_y}) is valid" if y
      puts "number: #{_number.to_s.red} (#{inx_x},#{inx_y}) is not valid" unless y
      y
    end
    puts "number: #{_number.to_s.green} is valid" if x
    puts "number: #{_number.to_s.red} is not valid" unless x
    x
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

# compare_solutions(4361, solve('test.txt'))
compare_solutions(4361, solve('test2.txt'))
compare_solutions(557_705, solve('input.txt'))
puts 'Part1', solve('input.txt')

compare_solutions(0, solve2('test.txt'))
puts 'Part2', solve2('input.txt')
