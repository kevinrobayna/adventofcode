# frozen_string_literal: true

def compare_solutions(expected, actual)
  raise "Expected #{expected} but got #{actual}" unless expected == actual

  puts "Congratulations! Got expected result (#{expected})"
end

def read_file(*args)
  File.read(File.join(File.absolute_path('.'), *args))
end

def solve(filename)
  read_file(filename)
  0
end

def solve2(filename)
  read_file(filename)
  0
end

compare_solutions(0, solve('2016/day-19/test.txt'))
puts 'Part1', solve('2016/day-19/input.txt')

compare_solutions(0, solve2('2016/day-19/test.txt'))
puts 'Part2', solve2('2016/day-19/input.txt')
