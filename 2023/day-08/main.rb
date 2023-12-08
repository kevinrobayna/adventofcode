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
  directions, *lines = read_file(filename).scan(/\w+/)
  count = 0
  nodes = lines.each_slice(3).reduce({}) do |acc, (source, left, right)|
    acc.merge(source.to_sym => { L: left, R: right })
  end
  node = 'AAA'.to_sym
  head = 0

  while node != :ZZZ
    next_side = directions[head % directions.length]
    next_node = nodes[node][next_side.to_sym].to_sym
    puts "Node:#{node} H:#{next_side} N:#{next_node}"

    count += 1
    head += 1
    node = next_node
  end
  count
end

def solve2(filename)
  read_file(filename)
  0
end

compare_solutions(2, solve('test.txt'))
compare_solutions(6, solve('test2.txt'))
puts 'Part1', solve('input.txt')

compare_solutions(0, solve2('test.txt'))
puts 'Part2', solve2('input.txt')
