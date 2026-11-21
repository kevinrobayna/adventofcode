# frozen_string_literal: true

require_relative '../../lib/aoc'

# Rock shapes as [dx, dy] cells, dy going up.
ROCKS = [
  [[0, 0], [1, 0], [2, 0], [3, 0]],
  [[1, 0], [0, 1], [1, 1], [2, 1], [1, 2]],
  [[0, 0], [1, 0], [2, 0], [2, 1], [2, 2]],
  [[0, 0], [0, 1], [0, 2], [0, 3]],
  [[0, 0], [1, 0], [0, 1], [1, 1]]
].freeze
WIDTH = 7
PROFILE_DEPTH = 30

class Chamber
  attr_reader :height

  def initialize(jets)
    @jets = jets
    @jet = 0
    @rows = [] # each row is a 7-bit mask
    @height = 0
  end

  def free?(rock, x, y)
    rock.all? do |dx, dy|
      cx = x + dx
      cy = y + dy
      cx.between?(0, WIDTH - 1) && cy >= 0 && (@rows[cy].to_i & (1 << cx)).zero?
    end
  end

  def drop(rock)
    x = 2
    y = @height + 3
    loop do
      shift = @jets[@jet] == '>' ? 1 : -1
      @jet = (@jet + 1) % @jets.size
      x += shift if free?(rock, x + shift, y)
      break unless free?(rock, x, y - 1)

      y -= 1
    end
    rock.each do |dx, dy|
      @rows[y + dy] = @rows[y + dy].to_i | (1 << (x + dx))
    end
    @height = @rows.size
  end

  def state(rock_index)
    [rock_index, @jet, @rows.last(PROFILE_DEPTH)]
  end
end

def tower_height(input, rocks)
  chamber = Chamber.new(input.strip.chars)
  seen = {}
  heights = []
  rocks.times do |n|
    key = chamber.state(n % ROCKS.size)
    if (start = seen[key])
      cycle = n - start
      growth = chamber.height - heights[start]
      cycles, rest = (rocks - start).divmod(cycle)
      return heights[start + rest] + (cycles * growth)
    end
    seen[key] = n
    heights << chamber.height
    chamber.drop(ROCKS[n % ROCKS.size])
  end
  chamber.height
end

def solve(input)
  tower_height(input, 2022)
end

def solve2(input)
  tower_height(input, 1_000_000_000_000)
end

class AoCTest < Minitest::Test
  EXAMPLE = ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>\n"

  def test_solve_example
    assert_equal 3068, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 3224, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 1_514_285_714_288, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 1_595_988_538_691, solve2(read_file('input.txt'))
  end
end
