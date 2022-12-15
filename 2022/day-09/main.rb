# frozen_string_literal: true

require 'set'

def compare_solutions(expected, actual)
  raise "Expected #{expected} but got #{actual}" unless expected == actual
end

def read_file(*args)
  File.read(File.join(File.absolute_path('.'), *args))
end

MOVEMENTS = {
  'R' => [1, 0],
  'L' => [-1, 0],
  'U' => [0, 1],
  'D' => [0, -1]
}.freeze

class Knot
  attr_reader :pos_x, :pos_y

  def initialize
    @pos_x = 0
    @pos_y = 0
    @memory = Set.new([0, 0])
  end

  def move(direction)
    next_x, next_y = MOVEMENTS[direction]
    @pos_x += next_x
    @pos_y += next_y

    @memory.add([@pos_x, @pos_y])
  end

  # Move tail to follow head
  # Since we are moving each position at the time, one node can be:
  #   0 steps away -> no movement
  #   1 or 2 steps away (ahead) -> move towards on the same axis (x++ or y++)
  #   -1 or -2 steps away (behind) -> move behind on the same axis (x-- or y--)
  def follow(other)
    return unless nearby?(other)

    move_x = other.pos_x - @pos_x
    move_y = other.pos_y - @pos_y
    @pos_x += move_x.abs == 2 ? move_x / 2 : move_x
    @pos_y += move_y.abs == 2 ? move_y / 2 : move_y

    @memory.add([@pos_x, @pos_y])
  end

  def steps
    @memory.size
  end

  private

  def nearby?(other)
    [(other.pos_x - @pos_x).abs, (other.pos_y - @pos_y).abs].max > 1
  end
end

def solve(filename)
  calculate_tail_positions(filename, 2)
end

def solve2(filename)
  calculate_tail_positions(filename, 10)
end

def calculate_tail_positions(filename, knot_count)
  knots = knot_count.times.map { Knot.new }

  read_file(filename).each_line.map do |line|
    direction, movement = line.split(' ')
    movement.to_i.times do
      knots.each.with_index do |knot, inx|
        if inx.zero?
          knot.move(direction)
        else
          knot.follow(knots[inx - 1])
        end
      end
    end
  end
  knots.last.steps
end

compare_solutions(13, solve('2022/day-09/test.txt'))
puts 'Part1', solve('2022/day-09/input.txt')

compare_solutions(1, solve2('2022/day-09/test.txt'))
compare_solutions(36, solve2('2022/day-09/test2.txt'))
puts 'Part2', solve2('2022/day-09/input.txt')
