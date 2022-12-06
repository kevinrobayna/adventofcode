# frozen_string_literal: true

def compare_solutions(expected, actual)
  raise "Expected #{expected} but got #{actual}" unless expected == actual
end

def read_file(*args)
  File.read(File.join(File.absolute_path('.'), *args))
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

compare_solutions(7, solve('2022/day-06/test.txt'))
compare_solutions(5, solve('2022/day-06/test2.txt'))
compare_solutions(6, solve('2022/day-06/test3.txt'))
compare_solutions(10, solve('2022/day-06/test4.txt'))
compare_solutions(11, solve('2022/day-06/test5.txt'))
puts 'Part1', solve('2022/day-06/input.txt')

compare_solutions(19, solve2('2022/day-06/test.txt'))
compare_solutions(23, solve2('2022/day-06/test2.txt'))
compare_solutions(23, solve2('2022/day-06/test3.txt'))
compare_solutions(29, solve2('2022/day-06/test4.txt'))
compare_solutions(26, solve2('2022/day-06/test5.txt'))
puts 'Part2', solve2('2022/day-06/input.txt')
