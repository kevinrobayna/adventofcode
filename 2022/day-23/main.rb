# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

# Positions are encoded as a single integer: row * STRIDE + col (with an offset so values stay positive).
STRIDE = 10_000
OFFSET = 5_000
N = -STRIDE
S = STRIDE
W = -1
E = 1
# Each proposal: [cells that must be empty, move].
PROPOSALS = [
  [[N + W, N, N + E], N],
  [[S + W, S, S + E], S],
  [[N + W, W, S + W], W],
  [[N + E, E, S + E], E]
].freeze
AROUND = [N + W, N, N + E, W, E, S + W, S, S + E].freeze

def parse_elves(input)
  elves = Set.new
  input.split("\n").each_with_index do |line, r|
    line.chars.each_with_index { |ch, c| elves << (((r + OFFSET) * STRIDE) + c + OFFSET) if ch == '#' }
  end
  elves
end

# Runs one round; returns whether any elf moved.
def spread(elves, round)
  targets = Hash.new { |h, k| h[k] = [] }
  elves.each do |elf|
    next if AROUND.none? { |d| elves.include?(elf + d) }

    4.times do |i|
      checks, move = PROPOSALS[(round + i) % 4]
      next unless checks.none? { |d| elves.include?(elf + d) }

      targets[elf + move] << elf
      break
    end
  end
  moved = false
  targets.each do |target, from|
    next unless from.size == 1

    elves.delete(from.first)
    elves << target
    moved = true
  end
  moved
end

def solve(input)
  elves = parse_elves(input)
  10.times { |round| spread(elves, round) }
  rows = elves.map { |e| e / STRIDE }
  cols = elves.map { |e| e % STRIDE }
  ((rows.max - rows.min + 1) * (cols.max - cols.min + 1)) - elves.size
end

def solve2(input)
  elves = parse_elves(input)
  round = 0
  round += 1 while spread(elves, round)
  round + 1
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    ....#..
    ..###.#
    #...#.#
    .#...##
    #.###..
    ##.#.##
    .#..#..
  INPUT

  def test_solve_example
    assert_equal 110, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 3987, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 20, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 938, solve2(read_file('input.txt'))
  end
end
