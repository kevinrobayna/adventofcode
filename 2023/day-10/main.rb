# frozen_string_literal: true

require 'pry'
require 'colorize'

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

def solve(filename)
  start = []
  grid = read_file(filename).each_line.with_index.map do |line, row|
    chars = line.strip.chars
    start = [[row, chars.index('S')]] if chars.include?('S')
    chars
  end
  queue = [start]
  until queue.empty?
    inx_x, inx_y = queue.pop
    p inx_x, inx_y
  end

end

def solve2(filename)
  read_file(filename)
  0
end

def next_positions(value)
  case value
  when '|'
    [[1, 0], [-1, 0]]
  when '-'
    [[0, 1], [0, 1]]
  when 'L'
    [[0, 1], [0, 1]]
  when 'J'
    [[0, 1], [0, 1]]
  when '7'
    [[0, 1], [0, 1]]
  when 'F'
    [[0, 1], [0, 1]]
  else
    []
  end
end

def debug_board(board)
  board.map do |row|
    row.map do |v|
      if v.nil?
        'x'.red
      else
        v.to_s.green
      end
    end
  end.map(&:join).join("\n")
end

compare_solutions(4, solve('test.txt'))
compare_solutions(4, solve('test2.txt'))
compare_solutions(8, solve('test3.txt'))
compare_solutions(8, solve('test4.txt'))
puts 'Part1', solve('input.txt')

compare_solutions(0, solve2('test.txt'))
puts 'Part2', solve2('input.txt')
