# frozen_string_literal: true

require 'ostruct'

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

def solve(filename)
  calculate_tail_positions(filename, 2)
end

def solve2(filename)
  calculate_tail_positions(filename, 10)
end

def calculate_tail_positions(filename, number_of_knots)
  positions = number_of_knots.times.map do
    [0, 0]
  end
  tail_positions = [positions.last]

  read_file(filename).each_line.map do |line|
    direction, movement = line.split(' ')
    movement.to_i.times do
      next_positions = positions.map.with_index do |_, inx|
        next_movement(direction, inx, positions)
      end
      positions = next_positions
      tail_positions << positions.last
    end
  end

  tail_positions.uniq.size
end

def next_movement(direction, inx, positions)
  if inx.zero?
    next_x, next_y = MOVEMENTS[direction]
    head_x, head_y = positions[inx]
    [head_x + next_x, head_y + next_y]
  else
    next_head = next_movement(direction, inx - 1, positions)
    # This is currently not working
    # Step 0
    # ......
    # ......
    # ......
    # ....H.
    # 4321..  (4 covers 5, 6, 7, 8, 9, s)
    # Step 1
    # ......
    # ......
    # ....H.
    # .4321.
    # 5.....  (5 covers 6, 7, 8, 9, s)
    #
    # Our result is different
    # ......
    # ......
    # ....H.
    # ....1.
    # 5432..  (5 covers 6, 7, 8, 9, s)
    #
    # Our logic sees that the distance from 2 to 1 is 1.42 so because is bellow 2 it won't move.
    if distance(next_head, positions[inx]) > 1
      positions[inx - 1]
    else
      positions[inx]
    end
  end
end

def distance(head, tail)
  head_x, head_y = head
  tail_x, tail_y = tail
  Math.sqrt((head_x - tail_x) ** 2 + (head_y - tail_y) ** 2).floor
end

compare_solutions(13, solve('2022/day-09/test.txt'))
puts 'Part1', solve('2022/day-09/input.txt')

compare_solutions(1, solve2('2022/day-09/test.txt'))
compare_solutions(36, solve2('2022/day-09/test2.txt'))
puts 'Part2', solve2('2022/day-09/input.txt')
