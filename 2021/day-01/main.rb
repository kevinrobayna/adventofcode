# frozen_string_literal: true

def compare_solutions(expected, actual)
  raise "Expected #{expected} but got #{actual}" unless expected == actual

  puts "Congratulations! Got expected result (#{expected})"
end

def read_file(*args)
  File.read(File.join(File.absolute_path('.'), *args))
end

def solve(filename)
  numbers = read_file(filename).split("\n").reject(&:empty?).map(&:to_i)
  count_increases(numbers)
end

def solve2(filename)
  numbers = read_file(filename).split("\n").reject(&:empty?).map(&:to_i)
  aggregated_numbers = []
  numbers.each_with_index do |value, index|
    next if index < 2

    aggregated_numbers.append(numbers[index - 2] + numbers[index - 1] + value)
  end
  count_increases(aggregated_numbers)
end

def count_increases(numbers)
  counter = 0
  numbers.each_with_index do |value, index|
    next if index.eql? 0

    counter += 1 if numbers[index - 1] < value
  end
  counter
end

compare_solutions(7, solve('2021/day-01/test.txt'))
puts 'Part1', solve('2021/day-01/input.txt')

compare_solutions(5, solve2('2021/day-01/test.txt'))
puts 'Part2', solve2('2021/day-01/input.txt')
