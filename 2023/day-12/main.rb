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
  read_file(filename).each_line.reduce(0) do |acc, line|
    springs, rules = line.strip.split(' ')
    springs = springs.chars
    rules = rules.split(',').map(&:to_i)

    matcher = Regexp.new("(#{springs.join.gsub('.', '\.').gsub('?', '(\?|.|#)')})")

    posibilities = create_table(springs.length).select do |values|
      values.join.match(matcher)
    end
    posibilities = posibilities.select do |values|
      found_pound = false
      count = 0
      combination = []
      values.each do |v|
        if v == '#'
          count += 1
          found_pound = true
        else
          next if found_pound == false || count.zero?

          combination << count
          count = 0
        end
      end
      if (found_pound == true) && (count != 0)

        combination << count
        count = 0
      end
      # puts "S:#{values.join}, R: #{rules} C:#{combination}"
      combination == rules
    end

    # puts "#Total:#{posibilities.length}\n\n"

    acc + posibilities.length
  end
end

def solve2(filename)
  read_file(filename)
  0
end

def create_table(n)
  %w[# .].repeated_permutation(n).to_a
end

compare_solutions(21, solve('test.txt'))
puts 'Part1', solve('input.txt')

compare_solutions(0, solve2('test.txt'))
puts 'Part2', solve2('input.txt')
