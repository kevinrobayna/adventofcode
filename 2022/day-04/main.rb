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
  read_file(filename).split("\n").map do |line|
    first_range, second_range = line.split(",").map { |it| to_range(it.strip) }
    sorted = [first_range, second_range].sort_by(&:size)
    short = sorted.first
    long = sorted.last
    ((short.first >= long.first) && (short.last <= long.last)) ? 1 : 0
  end.sum
end

def to_range(range)
  start, last = range.split("-").map(&:to_i)
  start..last
end

def solve2(filename)
  read_file(filename).split("\n").map do |line|
    first_range, second_range = line.split(",").map { |it| to_range(it.strip) }
    sorted = [first_range, second_range].sort_by(&:size)
    short = sorted.first
    long = sorted.last
    (short.to_a.any? { |it| long.include? it }) ? 1 : 0
  end.sum
end

compare_solutions(2, solve("test.txt"))
puts "Part1", solve("input.txt")

compare_solutions(4, solve2("test.txt"))
puts "Part2", solve2("input.txt")
