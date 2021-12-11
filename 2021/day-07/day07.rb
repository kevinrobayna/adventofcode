# frozen_string_literal: true

def read_file(*args)
  File.read(File.join(File.absolute_path(''), *args))
end

module Day07

  class Solver

    def initialize(content)
      @content = parse_content(content)
    end

    def solve
      med = median(@content).round
      @content.map { |x| (x - med).abs }.sum
    end

    def solve2
      costs = [average(@content).floor, average(@content).round].map do |avg|
        movements = @content.map do |x|
          steps = (x - avg).abs
          extra = steps.times.map { |y| y }.sum
          steps + extra
        end
        movements.sum
      end
      costs.min
    end

    private

    def median(array)
      sorted = array.sort
      ((sorted[(array.length - 1) / 2] + sorted[array.length / 2]) / 2.0)
    end

    def average(array)
      (array.sum(0.0) / array.length)
    end

    def parse_content(content)
      content.split("\n").first.split(',').map(&:to_i)
    end
  end
end

test = read_file('test.txt')
real = read_file('input.txt')

puts 'Part1 Test', Day07::Solver.new(test).solve
puts 'Part1', Day07::Solver.new(real).solve
puts 'Part2 Test', Day07::Solver.new(test).solve2
puts 'Part2', Day07::Solver.new(real).solve2


