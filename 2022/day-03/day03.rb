# frozen_string_literal: true

def compare_solutions(expected, actual)
  raise "Expected #{expected} but got #{actual}" unless expected == actual
end

def read_file(*args)
  File.read(File.join(File.absolute_path('.'), *args))
end

ALPHABET = ('a'..'z').to_a + ('A'..'Z').to_a

def solve(filename)
  read_file(filename).split("\n").map do |line|
    half_point = (line.length.to_f / 2).ceil
    first_half = line[0, half_point]
    second_half = line[half_point, line.length]
    matching = find_matching_char([first_half, second_half])
    ALPHABET.index(matching) + 1
  end.sum
end

def solve2(filename)
  group_size = 3
  read_file(filename).split("\n").each_slice(group_size).map do |slice|
    ALPHABET.index(find_matching_char(slice)) + 1
  end.sum
end

def find_matching_char(slice)
  longest = slice.max_by(&:size)
  others = slice.reject { |s| s == longest }
  hash = {}
  longest.each_char do |char|
    hash[char] = hash[char] ? hash[char] + 1 : 1 if others.all? { |s| s.include?(char) }
  end
  hash.select { |_k, v| v.positive? }.keys.first
end

compare_solutions(157, solve('2022/day-03/test.txt'))
puts 'Part1', solve('2022/day-03/input.txt')

compare_solutions(70, solve2('2022/day-03/test.txt'))
puts 'Part2', solve2('2022/day-03/input.txt')
