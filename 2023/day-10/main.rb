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

def solve(filename)
  start = []
  grid = read_file(filename).each_line.with_index.map do |line, row|
    chars = line.strip.chars
    start = [row, chars.index('S')] if chars.include?('S')
    chars
  end

  find_cycle(grid, start).length / 2
end

def solve2(filename)
  start = []
  grid = read_file(filename).each_line.with_index.map do |line, row|
    chars = line.strip.chars
    start = [row, chars.index('S')] if chars.include?('S')
    chars
  end

  cycle = find_cycle(grid, start)

  debug_board(grid, cycle)
end

def find_cycle(grid, start)
  start_neighburs = valid_movements(start, grid, next_positions(grid[start.first][start.last]))

  queue = [[start]]
  until queue.empty?
    path = queue.pop
    inx_x, inx_y = path.last

    next_paths = valid_movements([inx_x, inx_y], grid, next_positions(grid[inx_x][inx_y]))
                 .reject { |next_x, next_y| path.include?([next_x, next_y]) }

    return path if next_paths.empty? && (start_neighburs & path) == start_neighburs

    next_paths.each { |next_pos| queue << (path.dup << next_pos) }
  end
end

def next_positions(value)
  case value
  when 'S'
    [UP, DOWN, LEFT, RIGHT]
  when '|'
    [UP, DOWN]
  when '-'
    [RIGHT, LEFT]
  when 'L'
    [UP, RIGHT]
  when 'J'
    [UP, LEFT]
  when '7'
    [DOWN, LEFT]
  when 'F'
    [DOWN, RIGHT]
  else
    []
  end
end

def valid_movements(current, grid, movements)
  movements.map { |inc_x, inc_y| [current.first + inc_x, current.last + inc_y] }
           .select { |next_x, _next_y| next_x >= 0 && next_x <= grid.length }
           .select { |next_x, next_y| next_y >= 0 && next_y <= grid[next_x].length }
           .select do |x, y|
    next_positions(grid[x][y])
      .map { |inc_x, inc_y| [x + inc_x, y + inc_y] }
      .select { |next_x, _next_y| next_x >= 0 && next_x <= grid.length }
      .select { |next_x, next_y| next_y >= 0 && next_y <= grid[next_x].length }
      .include?(current)
  end
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
