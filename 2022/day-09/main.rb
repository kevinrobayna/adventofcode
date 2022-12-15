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

def solve(filename)
  calculate_tail_positions(filename, 2)
end

def solve2(filename)
  calculate_tail_positions(filename, 10)
end

def calculate_tail_positions(filename, knots)
  positions = knots.times.map do
    [0, 0]
  end
  tail_positions = Set[positions.last]

  read_file(filename).each_line.map do |line|
    direction, movement = line.split(' ')
    movement.to_i.times do
      positions.each.with_index do |_, inx|
        positions[inx] = if inx.zero?
                           head = positions[inx]
                           move(direction, head)
                         else
                           head = positions[inx - 1]
                           tail = positions[inx]
                           follow(head, tail)
                         end
      end
      tail_positions.add(positions.last)
    end
  end
  tail_positions.size
end

def move(direction, knot)
  next_x, next_y = MOVEMENTS[direction]
  knot_x, knot_y = knot
  [knot_x + next_x, knot_y + next_y]
end

def follow(head, tail)
  head_x, head_y = head
  tail_x, tail_y = tail
  distance = [(head_x - tail_x).abs, (head_y - tail_y).abs].max

  # Move tail to follow head
  # Since we are moving each position at the time, one node can be:
  #   0 steps away -> no movement
  #   1 or 2 steps away (ahead) -> move towards on the same axis (x++ or y++)
  #   -1 or -2 steps away (behind) -> move behind on the same axis (x-- or y--)
  return tail if distance <= 1

  move_x = head_x - tail_x
  move_y = head_y - tail_y
  next_x = move_x.abs == 2 ? move_x / 2 : move_x
  next_y = move_y.abs == 2 ? move_y / 2 : move_y
  [tail_x + next_x, tail_y + next_y]
end

compare_solutions(13, solve('2022/day-09/test.txt'))
puts 'Part1', solve('2022/day-09/input.txt')

compare_solutions(1, solve2('2022/day-09/test.txt'))
compare_solutions(36, solve2('2022/day-09/test2.txt'))
puts 'Part2', solve2('2022/day-09/input.txt')
