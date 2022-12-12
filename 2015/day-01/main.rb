# frozen_string_literal: true

def compare_solutions(expected, actual)
  raise "Expected #{expected} but got #{actual}" unless expected == actual
end

def read_file(*args)
  File.read(File.join(File.absolute_path('.'), *args))
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
    if char == '('
      1
    else
      -1
    end
  end
end

compare_solutions(-1, solve('2015/day-01/test.txt'))
puts 'Part1', solve('2015/day-01/input.txt')

compare_solutions(5, solve2('2015/day-01/test.txt'))
puts 'Part2', solve2('2015/day-01/input.txt')
