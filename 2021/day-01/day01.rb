# frozen_string_literal: true

def read_file(*args)
  File.read(File.join(File.absolute_path('.'), *args))
end

module Day01

  class Solver

    def initialize(content)
      @content = content
    end

    attr_reader :content

    def solve
      count_increases(parse_content)
    end

    def solve2
      numbers = parse_content
      aggregated_numbers = []
      numbers.each_with_index do |value, index|
        next if index < 2

        aggregated_numbers.append(numbers[index - 2] + numbers[index - 1] + value)
      end
      count_increases(aggregated_numbers)
    end

    private

    def count_increases(numbers)
      counter = 0
      numbers.each_with_index do |value, index|
        next if index.eql? 0

        counter += 1 if numbers[index - 1] < value
      end
      counter
    end

    def parse_content
      @content.split("\n").reject(&:empty?).map(&:to_i)
    end

  end
end

test = read_file('2021/day-01/test.txt')
real = read_file('2021/day-01/input.txt')

puts 'Part1 Test', Day01::Solver.new(test).solve
puts 'Part1', Day01::Solver.new(real).solve
puts 'Part2 Test', Day01::Solver.new(test).solve2
puts 'Part2', Day01::Solver.new(real).solve2

