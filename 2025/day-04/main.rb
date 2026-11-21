# frozen_string_literal: true

require_relative '../../lib/aoc'

NEIGHBOURS = [-1, 0, 1].product([-1, 0, 1]) - [[0, 0]]

def rolls(input)
  input.split.each_with_index.with_object(Set.new) do |(line, r), set|
    line.each_char.with_index { |ch, c| set << [r, c] if ch == '@' }
  end
end

def adjacent(roll)
  NEIGHBOURS.map { |dr, dc| [roll[0] + dr, roll[1] + dc] }
end

def accessible?(set, roll)
  adjacent(roll).count { |n| set.include?(n) } < 4
end

def solve(input)
  set = rolls(input)
  set.count { |roll| accessible?(set, roll) }
end

def solve2(input)
  set = rolls(input)
  queue = set.to_a
  removed = 0
  until queue.empty?
    roll = queue.pop
    next unless set.include?(roll) && accessible?(set, roll)

    set.delete(roll)
    removed += 1
    queue.concat(adjacent(roll).select { |n| set.include?(n) })
  end
  removed
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    ..@@.@@@@.
    @@@.@.@.@@
    @@@@@.@.@@
    @.@@@@..@.
    @@.@@@@.@@
    .@@@@@@@.@
    .@.@.@.@@@
    @.@@@.@@@@
    .@@@@@@@@.
    @.@.@@@.@.
  INPUT

  def test_solve_example
    assert_equal 13, solve(EXAMPLE)
  end

  def test_solve2_example
    assert_equal 43, solve2(EXAMPLE)
  end

  def test_solve_input
    assert_equal 1460, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 9243, solve2(read_file('input.txt'))
  end
end
