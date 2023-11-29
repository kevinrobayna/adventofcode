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
  get_sorted_snacks(filename).last
end

def solve2(filename)
  snacks = get_sorted_snacks(filename)
  snacks[-1] + snacks[-2] + snacks[-3]
end

def get_sorted_snacks(filename)
  sums = [0]
  read_file(filename).split("\n").each do |line|
    if line.empty?
      sums.push(0)
      next
    end

    sums[-1] = sums[-1] + line.to_i
  end
  sums.sort
end

compare_solutions(24_000, solve('test.txt'))
puts 'Part1', solve('input.txt')

compare_solutions(45_000, solve2('test.txt'))
puts 'Part2', solve2('input.txt')
