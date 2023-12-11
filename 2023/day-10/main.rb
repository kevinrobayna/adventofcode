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

UP = [-1, 0].freeze
DOWN = [1, 0].freeze
RIGHT = [0, 1].freeze
LEFT = [0, -1].freeze

DIR = {
  '|' => [UP, DOWN],
  '-' => [RIGHT, LEFT],
  'L' => [UP, RIGHT],
  'J' => [UP, LEFT],
  'F' => [DOWN, RIGHT],
  '7' => [DOWN, LEFT],
  '.' => [],
  'S' => []
}.freeze

def solve(filename)
  start, grid = parse_file(filename)

  find_cycle(grid, start).length / 2
end

def solve2(filename)
  start, grid = parse_file(filename)

  cycle = find_cycle(grid, start)

  debug_board(grid, cycle)
end

def parse_file(filename)
  start = []
  grid = read_file(filename).each_line.with_index.map do |line, row|
    chars = line.strip.chars
    start = [row, chars.index('S')] if chars.include?('S')
    chars
  end

  [start, grid]
end

def find_cycle(grid, start)
  start_neighbors = [UP, DOWN, LEFT, RIGHT].map do |dx, dy|
    [start.first + dx, start.last + dy]
  end.select do |pos|
    neighbors(pos, grid).include?(start)
  end

  start_point = start_neighbors.first
  pipe = [start, start_point].to_set
  while start_point != start_neighbors.last
    neighbors(start_point, grid).each do |neighbor|
      unless pipe.include?(neighbor)
        pipe << neighbor
        start_point = neighbor
      end
    end
  end
  pipe
end

def neighbors(current, grid)
  x, y = current
  DIR[grid[x][y]].map { |inc_x, inc_y| [x + inc_x, y + inc_y] }
end

def debug_board(board, path)
  board.each_with_index.map do |row, inx_x|
    row.each_with_index.map do |v, inx_y|
      if path.include?([inx_x, inx_y])
        v.green
      else
        v.red
      end
    end
  end.map(&:join).join("\n") + "\n" + "\n"
end

# Easy ones
compare_solutions(4, solve('test.txt'))
compare_solutions(8, solve('test3.txt'))

# Annoying ones
compare_solutions(4, solve('test2.txt'))
compare_solutions(8, solve('test4.txt'))
puts 'Part1', solve('input.txt')

compare_solutions(4, solve2('test5.txt'))
compare_solutions(8, solve2('test6.txt'))
compare_solutions(10, solve2('test7.txt'))
puts 'Part2', solve2('input.txt')
