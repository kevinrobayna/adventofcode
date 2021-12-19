# frozen_string_literal: true

require 'ostruct'

def read_file(*args)
  File.read(File.join(File.absolute_path(''), *args))
end

module Day08

  class Solver

    def initialize(content)
      @content = parse_content(content)
      @digits = {
        0 => OpenStruct.new(count: 6, a: true, b: true, c: true, e: true, f: true, g: true),
        1 => OpenStruct.new(count: 2, c: true, f: true),
        2 => OpenStruct.new(count: 5, a: true, c: true, d: true, e: true, g: true),
        3 => OpenStruct.new(count: 5, a: true, c: true, d: true, f: true, g: true),
        4 => OpenStruct.new(count: 4, b: true, c: true, d: true, f: true),
        5 => OpenStruct.new(count: 5, a: true, b: true, d: true, f: true, g: true),
        6 => OpenStruct.new(count: 6, a: true, b: true, d: true, e: true, f: true, g: true),
        7 => OpenStruct.new(count: 3, a: true, c: true, f: true),
        8 => OpenStruct.new(count: 7, a: true, b: true, c: true, d: true, e: true, f: true, g: true),
        9 => OpenStruct.new(count: 6, a: true, b: true, c: true, d: true, f: true, g: true)
      }.freeze
    end

    def solve
      @content.map { |line| line[:output].map { |output| is_unique_char_digit?(output) ? 1 : 0 }.sum }.sum
    end

    def solve2
      0
    end

    private

    def is_unique_char_digit?(output)
      [@digits[1].count, @digits[4].count, @digits[7].count, @digits[8].count].include? output.length
    end

    def parse_content(content)
      content.split("\n").map do |line|
        input, output = line.split('|')
        { entry: input.strip.split(' '), output: output.strip.split(' ') }
      end
    end
  end
end

test = read_file('2021/day-08/test.txt')
real = read_file('2021/day-08/input.txt')

puts 'Part1 Test', Day08::Solver.new(test).solve
puts 'Part1', Day08::Solver.new(real).solve
puts 'Part2 Test', Day08::Solver.new(test).solve2
puts 'Part2', Day08::Solver.new(real).solve2


