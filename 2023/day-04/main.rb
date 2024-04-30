# frozen_string_literal: true

require "pry"
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

def parse_problem(filename)
  read_file(filename).each_line.map do |line|
    _, numbers = line.split(":")
    left, right = numbers.split("|")
    left.strip.split(" ").sort & right.strip.split(" ").sort
  end
end

def solve(filename)
  parse_problem(filename).reduce(0) do |acc, numbers|
    acc + if numbers.empty?
      0
    elsif numbers.length == 1
      1
    else
      result = 1
      (numbers.length - 1).times { result *= 2 }

      result
    end
  end
end

def solve2(filename)
  scratchcards = []
  parse_problem(filename).each_with_index do |numbers, inx|
    current = inx + 1
    scratchcards << current
    state = scratchcards.tally
    (1..numbers.length).each do |x|
      state[current].times { scratchcards << current + x }
    end
  end

  scratchcards.tally.values.sum
end

compare_solutions(13, solve("test.txt"))
puts "Part1", solve("input.txt")

compare_solutions(30, solve2("test.txt"))
puts "Part2", solve2("input.txt")
