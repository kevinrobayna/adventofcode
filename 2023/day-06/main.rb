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
  input = read_file(filename).lines
  times = input.first.scan(/\d+/).map(&:to_i)
  distances = input.last.scan(/\d+/).map(&:to_i)

  calculate_ways(times, distances)
end

def solve2(filename)
  input = read_file(filename).lines
  times = input.first.scan(/\d+/).join.to_i
  distances = input.last.scan(/\d+/).join.to_i

  calculate_ways([times], [distances])
end

def calculate_ways(times, distances)
  times.zip(distances).reduce(1) do |acc, (t, d)|
    ways = (1...t).filter do |hold|
      (t - hold) * hold > d
    end
    acc * ways.length
  end
end

compare_solutions(288, solve('test.txt'))
puts 'Part1', solve('input.txt')

compare_solutions(71_503, solve2('test.txt'))
puts 'Part2', solve2('input.txt')
