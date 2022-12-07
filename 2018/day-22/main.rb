# frozen_string_literal: true

def compare_solutions(expected, actual)
  raise "Expected #{expected} but got #{actual}" unless expected == actual
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

compare_solutions(0, solve('2018/day-22/test.txt'))
puts 'Part1', solve('2018/day-22/input.txt')

compare_solutions(0, solve2('2018/day-22/test.txt'))
puts 'Part2', solve2('2018/day-22/input.txt')
