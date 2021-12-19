# frozen_string_literal: true

require 'ostruct'

def read_file(*args)
  File.read(File.join(File.absolute_path(''), *args))
end

module Day02

  class Solver

    def initialize(content)
      @content = content
    end

    attr_reader :content

    def solve
      movement = OpenStruct.new(x: 0, y: 0)
      parse_content.each do |point|
        movement.x += point.x
        movement.y += point.y
      end
      movement.x * movement.y
    end

    def solve2
      aim = 0
      depth = 0
      position = 0

      parse_content.each do |point|
        aim += point.y
        position += point.x
        depth += (aim * point.x)
      end
      position * depth
    end

    private

    def parse_content
      @content.split("\n").map do |string|
        point = OpenStruct.new(x: 0, y: 0)
        direction = string.split(' ')
        increase = direction[1].to_i
        case direction.first
        when 'forward'
          point.x = 1 * increase
        when 'up'
          point.y = -1 * increase
        when 'down'
          point.y = 1 * increase
        else
          raise 'Unknown direction'
        end
        point
      end
    end

  end
end

test = read_file('2021/day-02/test.txt')
real = read_file('2021/day-02/input.txt')

puts 'Part1 Test', Day02::Solver.new(test).solve
puts 'Part1', Day02::Solver.new(real).solve
puts 'Part2 Test', Day02::Solver.new(test).solve2
puts 'Part2', Day02::Solver.new(real).solve2
