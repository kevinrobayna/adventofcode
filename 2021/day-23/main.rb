# frozen_string_literal: true

require_relative '../../lib/aoc'
require_relative '../min_heap'

ENERGY = { 'A' => 1, 'B' => 10, 'C' => 100, 'D' => 1000 }.freeze
DOORS = [2, 4, 6, 8].freeze
HALL_STOPS = ((0..10).to_a - DOORS).freeze
HALL_SIZE = 11

# State is a string: 11 hallway cells followed by each room's cells from top to bottom.
def parse(input, extra_rows: [])
  rows = input.split("\n").map { |line| line.scan(/[A-D]/) }.reject(&:empty?)
  rows = [rows.first, *extra_rows.map(&:chars), *rows.drop(1)]
  rooms = rows.transpose.map(&:join)
  [('.' * HALL_SIZE) + rooms.join, rows.size]
end

def room_index(room, slot, depth)
  HALL_SIZE + (room * depth) + slot
end

def hall_clear?(state, from, to)
  range = from < to ? (from + 1..to) : (to...from)
  range.all? { |i| state[i] == '.' }
end

def moves(state, depth)
  result = []
  # Hallway -> destination room.
  (0...HALL_SIZE).each do |h|
    kind = state[h]
    next if kind == '.'

    room = kind.ord - 65
    cells = (0...depth).map { |slot| state[room_index(room, slot, depth)] }
    next unless cells.all? { |c| c == '.' || c == kind } && hall_clear?(state, h, DOORS[room])

    slot = cells.rindex('.')
    nxt = state.dup
    nxt[h] = '.'
    nxt[room_index(room, slot, depth)] = kind
    result << [nxt, ((h - DOORS[room]).abs + slot + 1) * ENERGY[kind]]
  end
  # Room -> hallway.
  4.times do |room|
    cells = (0...depth).map { |slot| state[room_index(room, slot, depth)] }
    slot = cells.index { |c| c != '.' }
    next unless slot
    next if cells[slot..].all? { |c| c.ord - 65 == room }

    kind = cells[slot]
    HALL_STOPS.each do |h|
      next unless hall_clear?(state, DOORS[room], h) && state[h] == '.'

      nxt = state.dup
      nxt[room_index(room, slot, depth)] = '.'
      nxt[h] = kind
      result << [nxt, ((h - DOORS[room]).abs + slot + 1) * ENERGY[kind]]
    end
  end
  result
end

def least_energy(state, depth)
  goal = ('.' * HALL_SIZE) + %w[A B C D].map { |k| k * depth }.join
  dist = { state => 0 }
  heap = MinHeap.new
  heap.push([0, state])
  until heap.empty?
    cost, current = heap.pop
    return cost if current == goal
    next if cost > dist[current]

    moves(current, depth).each do |nxt, step|
      new_cost = cost + step
      next if dist.fetch(nxt, Float::INFINITY) <= new_cost

      dist[nxt] = new_cost
      heap.push([new_cost, nxt])
    end
  end
end

def solve(input)
  least_energy(*parse(input))
end

def solve2(input)
  least_energy(*parse(input, extra_rows: %w[DCBA DBAC]))
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    #############
    #...........#
    ###B#C#B#D###
      #A#D#C#A#
      #########
  INPUT

  def test_solve_example
    assert_equal 12_521, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 15_338, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 44_169, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 47_064, solve2(read_file('input.txt'))
  end
end
