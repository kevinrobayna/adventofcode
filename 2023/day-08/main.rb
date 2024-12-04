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
  directions, nodes = parse_file(filename)
  count = 0
  node = :AAA
  head = 0

  while node != :ZZZ
    next_side = directions[head % directions.length]
    node = nodes[node][next_side.to_sym].to_sym

    count += 1
    head += 1
  end
  count
end

def solve2(filename)
  directions, nodes = parse_file(filename)
  count = 0
  head = 0
  node_head = nodes.select { _1[2] == 'A' }.keys.sort
  desired_end = nodes.select { _1[2] == 'Z' }.keys.sort
  cycles = []

  until node_head.empty?
    next_side = directions[head % directions.length]
    node_head = node_head.map { |node| nodes[node][next_side.to_sym].to_sym }.sort

    count += 1
    head += 1

    node_head = node_head.reject do |node|
      cycles << count if desired_end.include?(node)

      desired_end.include?(node)
    end
  end

  cycles.reduce(1) { |acc, cycle| acc.lcm(cycle) }
end

def parse_file(filename)
  directions, *lines = read_file(filename).scan(/\w+/)
  nodes = lines.each_slice(3).reduce({}) do |acc, (source, left, right)|
    acc.merge(source.to_sym => { L: left, R: right })
  end
  [directions, nodes]
end

compare_solutions(2, solve('test.txt'))
compare_solutions(6, solve('test2.txt'))
puts 'Part1', solve('input.txt')

compare_solutions(2, solve2('test.txt'))
compare_solutions(6, solve2('test2.txt'))
compare_solutions(6, solve2('test3.txt'))
puts 'Part2', solve2('input.txt')
