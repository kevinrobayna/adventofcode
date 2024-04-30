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
  parse_input(filename).sum
end

def solve2(filename)
  floor = 0
  parse_input(filename).each_with_index do |value, id|
    return id + 1 if floor + value == -1

    floor += value
  end
end

def parse_input(filename)
  read_file(filename).each_char.map do |char|
    if char == "("
      1
    else
      -1
    end
  end
end

compare_solutions(-1, solve("test.txt"))
puts "Part1", solve("input.txt")

compare_solutions(5, solve2("test.txt"))
puts "Part2", solve2("input.txt")
