# frozen_string_literal: true

require_relative '../../lib/aoc'

RubyVM::YJIT.enable if defined?(RubyVM::YJIT)

CLEAN = 0
WEAKENED = 1
INFECTED = 2
FLAGGED = 3
SIDE = 4096

# Simulates the virus carrier on a flat array grid; `next_state` maps node state -> new state.
# Returns how many bursts caused an infection.
def virus(input, bursts, next_state)
  rows = input.lines.map(&:strip).reject(&:empty?)
  grid = Array.new(SIDE * SIDE, CLEAN)
  offset = (SIDE - rows.size) / 2
  rows.each_with_index do |row, y|
    row.each_char.with_index { |c, x| grid[((y + offset) * SIDE) + x + offset] = INFECTED if c == '#' }
  end
  pos = ((offset + (rows.size / 2)) * SIDE) + offset + (rows.size / 2)
  moves = [-SIDE, 1, SIDE, -1] # up, right, down, left
  dir = 0
  infections = 0
  bursts.times do
    state = grid[pos]
    dir = case state
          when CLEAN then (dir + 3) & 3
          when INFECTED then (dir + 1) & 3
          when FLAGGED then (dir + 2) & 3
          else dir
          end
    state = next_state[state]
    grid[pos] = state
    infections += 1 if state == INFECTED
    pos += moves[dir]
  end
  infections
end

def solve(input, bursts: 10_000)
  virus(input, bursts, [INFECTED, nil, CLEAN, nil])
end

def solve2(input, bursts: 10_000_000)
  virus(input, bursts, [WEAKENED, INFECTED, FLAGGED, CLEAN])
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    ..#
    #..
    ...
  INPUT

  def test_solve_example
    assert_equal 5, solve(EXAMPLE, bursts: 7)
    assert_equal 41, solve(EXAMPLE, bursts: 70)
    assert_equal 5587, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 5_570, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 26, solve2(EXAMPLE, bursts: 100)
    assert_equal 2_511_944, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 2_512_022, solve2(read_file('input.txt'))
  end
end
