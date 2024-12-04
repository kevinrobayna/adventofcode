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

def solve(filename, difference = 2)
  small_grid = read_file(filename).each_line.map do |line|
    line.strip.chars
  end

  positions = []
  empty_columns = Set.new
  empty_rows = Set.new

  small_grid.each_with_index do |row, inx_x|
    row.each_with_index do |v, inx_y|
      positions << [inx_x, inx_y] if v == '#'
      if small_grid.none? { |r| r[inx_y] == '#' } && !row.include?('#')
        empty_rows << inx_x
        empty_columns << inx_y
      end
    end
  end

  positions.combination(2).sum do |p1, p2|
    distance(p1, p2, empty_rows, empty_columns, difference)
  end
end

def distance(point1, point2, empty_rows, empty_columns, separtion)
  x, y = point1
  dx, dy = point2

  distance = (x - dx).abs + (y - dy).abs

  x_min, x_max = [x, dx].minmax
  y_min, y_max = [y, dy].minmax
  distance += (empty_rows.select { _1.between?(x_min, x_max) }.length * (separtion - 1))
  distance += (empty_columns.select { _1.between?(y_min, y_max) }.length * (separtion - 1))

  distance
end

def debug_board(board)
  board.each_with_index.map do |row, _inx_x|
    row.each_with_index.map do |v, inx_y|
      if v != '.'
        v.red
      elsif board.none? { |r| r[inx_y] == '#' } && !row.include?('#')
        v.green
      else
        v.blue
      end
    end
  end.map(&:join).join("\n")
end

compare_solutions(374, solve('test.txt', 2))
compare_solutions(1030, solve('test.txt', 10))
compare_solutions(8410, solve('test.txt', 100))
puts 'Part1', solve('input.txt', 2)
puts 'Part2', solve('input.txt', 1_000_000)
