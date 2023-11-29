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
  find_position_with_n_unique_chars(4, read_file(filename))
end

def solve2(filename)
  find_position_with_n_unique_chars(14, read_file(filename))
end

def find_position_with_n_unique_chars(number_of_unique_chars, content)
  content.chars.each_index do |index|
    next if index < number_of_unique_chars

    sequence = content[(index - number_of_unique_chars)...index]
    return index if sequence.chars.uniq.length == number_of_unique_chars
  end
  raise 'No solution found'
end

compare_solutions(7, solve('test.txt'))
compare_solutions(5, solve('test2.txt'))
compare_solutions(6, solve('test3.txt'))
compare_solutions(10, solve('test4.txt'))
compare_solutions(11, solve('test5.txt'))
puts 'Part1', solve('input.txt')

compare_solutions(19, solve2('test.txt'))
compare_solutions(23, solve2('test2.txt'))
compare_solutions(23, solve2('test3.txt'))
compare_solutions(29, solve2('test4.txt'))
compare_solutions(26, solve2('test5.txt'))
puts 'Part2', solve2('input.txt')
