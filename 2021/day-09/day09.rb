# frozen_string_literal: true

def read_file(*args)
  File.read(File.join(File.absolute_path(''), *args))
end

module Day09

  class Solver

    def initialize(content)
      @content = parse_content(content)
    end

    def solve
      risks = @content.each_with_index.map do |_, row|
        _.each_with_index.map { |value, column| low_point?(row, column) ? value + 1 : 0 }.sum
      end
      risks.sum
    end

    def solve2
      0
    end

    private

    def low_point?(i, j)
      value = @content[i][j]
      up = down = left = right = 9e9
      up = @content[i - 1][j] unless (i - 1).negative?
      down = @content[i + 1][j] unless (i + 1) > (@content.length - 1)

      left = @content[i][j - 1] unless (j - 1).negative?
      right = @content[i][j + 1] unless (j + 1) > (@content.first.length - 1)

      min = [value, up, down, left, right].min
      min == value && [value, up, down, left, right].select { |it| it == min }.count == 1
    end

    def parse_content(content)
      content.split("\n").map { |line| line.split('').map(&:to_i) }
    end
  end
end

test = read_file('test.txt')
real = read_file('input.txt')

puts 'Part1 Test', Day09::Solver.new(test).solve
puts 'Part1', Day09::Solver.new(real).solve
puts 'Part2 Test', Day09::Solver.new(test).solve2
puts 'Part2', Day09::Solver.new(real).solve2



