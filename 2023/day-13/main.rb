# frozen_string_literal: true

require 'pry'

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
  parse_input(filename)
    .each_with_index.sum do |pattern, _pattern_no|
    n_columns = find_matching(pattern)
    n_rows = find_matching(pattern.transpose)
    n_rows.first.to_i * 100 + n_columns.first.to_i
  end
end

def solve2(filename)
  parse_input(filename)
    .each_with_index.sum do |pattern, _pattern_no|
    n_columns = find_matching(pattern)
    n_rows = find_matching(pattern.transpose)

    columns = Set.new
    rows = Set.new
    pattern.each_with_index do |line, inx_x|
      line.each_with_index do |char, inx_y|
        pattern_x = pattern.map(&:dup)
        pattern_x[inx_x][inx_y] = char == '#' ? '.' : '#'
        columns += find_matching(pattern_x)
        rows += find_matching(pattern_x.transpose)
      end
    end

    columns -= n_columns
    rows -= n_rows
    rows.first.to_i * 100 + columns.first.to_i
  end
end

def parse_input(filename)
  read_file(filename)
    .split("\n\n")
    .map { _1.split("\n").map(&:chars) }
end

def find_matching(pattern)
  pattern.map do |line|
    (1...line.size).select do |inx|
      left, right = line.partition.with_index { |_, i| i < inx }
      min_partition = [left.length, right.length].min
      left.reverse[0...min_partition] == right[0...min_partition]
    end
  end.reduce(&:&)
end

compare_solutions(405, solve('test.txt'))
puts 'Part1', solve('input.txt')

compare_solutions(400, solve2('test.txt'))
puts 'Part2', solve2('input.txt')
