# frozen_string_literal: true

require 'pry'

class Object
  def number?
    to_f.to_s == to_s || to_i.to_s == to_s
  end
end

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
  read_file(filename).each_line.map do |line|
    numbers = line.chars.select(&:number?)
    "#{numbers.first}#{numbers.last}".to_i
  end.sum
end

NUMBERS_MAP = {
  one: 1,
  two: 2,
  three: 3,
  four: 4,
  five: 5,
  six: 6,
  seven: 7,
  eight: 8,
  nine: 9
}.freeze

def solve2(filename)
  read_file(filename).each_line.map do |line|
    line = line.gsub("\n", '')
    parsed_line = []
    head = 0
    (1..line.chars.length).each do |tail|
      str_to_check = line[head...tail]
      NUMBERS_MAP.each do |key, value|
        if str_to_check.include?(key.to_s)
          parsed_line << value
          head = tail - 1
        elsif str_to_check.include?(value.to_s)
          parsed_line << value
          head = tail
        end
      end
    end
    result = "#{parsed_line.first}#{parsed_line.last}".to_i

    # puts "line: #{line.gsub("\n", '')}, numbers: #{parsed_line} result: #{result}"
    result
  end.sum
end

compare_solutions(142, solve('test.txt'))
puts 'Part1', solve('input.txt')

compare_solutions(142, solve2('test.txt'))
compare_solutions(281, solve2('test2.txt'))
puts 'Part2', solve2('input.txt')
