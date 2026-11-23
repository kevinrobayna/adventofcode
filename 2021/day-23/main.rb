# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end
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

# A* lower bound (never overestimates): every amphipod not yet settled must walk to its
# room's door, and the ones entering a room fill its free slots from the bottom up.
# Amphipods in their own room above a stranger must step out (and back) first.
def min_remaining_energy(state, depth)
  total = 0
  entering = Array.new(4, 0)
  (0...HALL_SIZE).each do |h|
    kind = state[h]
    next if kind == '.'

    target = kind.ord - 65
    total += (h - DOORS[target]).abs * ENERGY[kind]
    entering[target] += 1
  end
  4.times do |room|
    settled_below = true
    (depth - 1).downto(0) do |slot|
      kind = state[room_index(room, slot, depth)]
      next if kind == '.'

      target = kind.ord - 65
      settled_below &&= target == room
      next if settled_below

      # Out of the room, then across to its door (at least one step aside and back if it is home).
      across = target == room ? 2 : (DOORS[room] - DOORS[target]).abs
      total += (slot + 1 + across) * ENERGY[kind]
      entering[target] += 1
    end
  end
  # The n amphipods entering a room walk 1, 2, ..., n steps down into it.
  entering.each_with_index { |n, room| total += n * (n + 1) / 2 * ENERGY[(room + 65).chr] }
  total
end

def least_energy(state, depth)
  goal = ('.' * HALL_SIZE) + %w[A B C D].map { |k| k * depth }.join
  dist = { state => 0 }
  heap = MinHeap.new
  heap.push([min_remaining_energy(state, depth), 0, state])
  until heap.empty?
    _, cost, current = heap.pop
    return cost if current == goal
    next if cost > dist[current]

    moves(current, depth).each do |nxt, step|
      new_cost = cost + step
      next if dist.fetch(nxt, Float::INFINITY) <= new_cost

      dist[nxt] = new_cost
      heap.push([new_cost + min_remaining_energy(nxt, depth), new_cost, nxt])
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

  def test_min_remaining_energy
    assert_equal 0, min_remaining_energy("#{'.' * 11}AABBCCDD", 2)
    # A in the hallway at 0: 2 steps to door 2, 1 step into the room.
    assert_equal 3, min_remaining_energy("A#{'.' * 10}.ABBCCDD", 2)
    # D atop room A and A atop room D swap: each is 1 out + 6 across + 1 in (1000 + 1 energy).
    assert_equal 8008, min_remaining_energy("#{'.' * 11}DABBCCAD", 2)
    assert_operator min_remaining_energy(*parse(EXAMPLE)), :<=, 12_521
  end

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
