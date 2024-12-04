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
  explore_history(filename).sum { |values| values.reverse.sum(&:last) }
end

def solve2(filename)
  explore_history(filename).sum do |values|
    result = 0
    (values.length - 2).downto(0).each do |inx|
      result = values[inx].first - result
    end
    result
  end
end

def explore_history(filename)
  read_file(filename).each_line.map { |line| line.split(' ').map(&:to_i) }.map do |current|
    values = [current]
    row = 0
    until values[row].all?(&:zero?)
      values << Array.new(values[row].length - 1) do |i|
        values[row][i + 1] - values[row][i]
      end
      row += 1
    end
    values
  end
end

compare_solutions(114, solve('test.txt'))
puts 'Part1', solve('input.txt')

compare_solutions(5, solve2('test2.txt'))
compare_solutions(2, solve2('test.txt'))
puts 'Part2', solve2('input.txt')
