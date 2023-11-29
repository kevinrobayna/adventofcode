# frozen_string_literal: true

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
  read_file(filename)
  0
end

def solve2(filename)
  read_file(filename)
  0
end

compare_solutions(0, solve('2015/day-12/test.txt'))
puts 'Part1', solve('2015/day-12/input.txt')

compare_solutions(0, solve2('2015/day-12/test.txt'))
puts 'Part2', solve2('2015/day-12/input.txt')
