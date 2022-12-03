# frozen_string_literal: true

require 'ostruct'

def compare_solutions(expected, actual)
  raise "Expected #{expected} but got #{actual}" unless expected == actual
end

def read_file(*args)
  File.read(File.join(File.absolute_path('.'), *args))
end

def solve(filename)
  movement = OpenStruct.new(x: 0, y: 0)
  parse_content(filename).each do |point|
    movement.x += point.x
    movement.y += point.y
  end
  movement.x * movement.y
end

def solve2(filename)
  aim = 0
  depth = 0
  position = 0

  parse_content(filename).each do |point|
    aim += point.y
    position += point.x
    depth += (aim * point.x)
  end
  position * depth
end

def parse_content(filename)
  read_file(filename).split("\n").map do |string|
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

compare_solutions(150, solve('2021/day-02/test.txt'))
puts 'Part1', solve('2021/day-02/input.txt')

compare_solutions(900, solve2('2021/day-02/test.txt'))
puts 'Part2', solve2('2021/day-02/input.txt')
