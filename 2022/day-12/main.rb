# frozen_string_literal: true

require 'matrix'

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

def parse_file(filename)
  alphabet = ('a'..'z').to_a
  lines = read_file(filename).split("\n")
  m = Matrix.zero(lines.length, lines[0].length)
  start = nil
  finish = nil
  lines.each_with_index do |line, inx_i|
    line.chars.each_with_index do |letter, inx_j|
      if letter == 'E'
        m[inx_i, inx_j] = alphabet.index('z')
        finish = [inx_i, inx_j]
        next
      end
      if letter == 'S'
        m[inx_i, inx_j] = alphabet.index('a')
        start = [inx_i, inx_j]
        next
      end

      m[inx_i, inx_j] = alphabet.index(letter)
    end
  end
  [m, start, finish]
end

MOVEMENTS = [
  [1, 0], # R
  [-1, 0], # L
  [0, 1], # U
  [0, -1] # D
].freeze

class Path
  attr_reader :current, :positions

  def initialize(current, peak, positions = 0)
    @current = current
    @positions = positions
    @peak = peak
    @height = 0
  end

  def move?(map, visited, dir)
    next_x, next_y = next_position(dir)

    # Position needs to be within the limits of the map
    return false unless next_x < map.row_count && next_y < map.column_count && next_x >= 0 && next_y >= 0

    # We don't want to visit already visited places
    return false unless (visited[next_x, next_y]).zero?

    current_x, current_y = @current
    h = map[current_x, current_y]

    # We can only go up one step at the time
    return (map[next_x, next_y] - h).abs <= 1 if map[next_x, next_y] >= h

    # We can go down as much as we want
    true
  end

  def move(dir)
    position = next_position(dir)
    @current = position
    @positions += 1
  end

  def next_position(dir)
    dir_x, dir_y = dir
    next_x = @current[0] + dir_x
    next_y = @current[1] + dir_y
    [next_x, next_y]
  end
end

def solve(filename)
  grid, start, finish = parse_file(filename)
  find_shortest_path(grid, start, finish).positions
end

def solve2(filename)
  grid, _, finish = parse_file(filename)
  start_positions = []
  grid.each_with_index do |h, i, j|
    start_positions.push([i, j]) if h.zero?
  end
  start_positions.map do |start|
    p = find_shortest_path(grid, start, finish)
    if p.nil?
      # Is this cheating? Don't know but it works ¯\_(ツ)_/¯
      nil
    else
      p.positions
    end
  end.compact.min
end

def find_shortest_path(grid, start, finish)
  visited = Matrix.zero(grid.row_count, grid.column_count)
  q = [Path.new(start, grid.map { |height, _i, _j| height }.max)]
  while q.any?
    path = q.shift
    current_x, current_y = path.current

    next if visited[current_x, current_y] == 1

    visited[current_x, current_y] = 1

    return path if path.current == finish

    MOVEMENTS.filter { |dir| path.move?(grid, visited, dir) }.each do |dir|
      clone = path.clone
      clone.move(dir)
      q.push(clone)
    end
  end
end

compare_solutions(31, solve('2022/day-12/test.txt'))
puts 'Part1', solve('2022/day-12/input.txt')

compare_solutions(29, solve2('2022/day-12/test.txt'))
puts 'Part2', solve2('2022/day-12/input.txt')
