# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def bugs(input) = input.split.join.chars.each_index.select { input.split.join[it] == '#' }

def lives?(bug, count) = bug ? count == 1 : [1, 2].include?(count)

def flat_neighbours(i)
  x = i % 5
  y = i / 5
  [[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]].select { |a, b| a.between?(0, 4) && b.between?(0, 4) }
                                                  .map { |a, b| (b * 5) + a }
end

def solve(input)
  state = bugs(input).sum { 1 << it }
  seen = {}
  until seen[state]
    seen[state] = true
    state = (0...25).sum do |i|
      count = flat_neighbours(i).count { state[it] == 1 }
      lives?(state[i] == 1, count) ? 1 << i : 0
    end
  end
  state
end

CENTER = 12

# Neighbours of tile i at depth d in the recursive grid, as [depth, tile]. Depth + 1 is the inner grid.
def recursive_neighbours(depth, i)
  x = i % 5
  y = i / 5
  [[-1, 0], [1, 0], [0, -1], [0, 1]].flat_map do |dx, dy|
    nx = x + dx
    ny = y + dy
    if !nx.between?(0, 4) || !ny.between?(0, 4)
      [[depth - 1, ((2 + dy) * 5) + 2 + dx]]
    elsif (ny * 5) + nx == CENTER
      edge = (0..4).map { |k| { [1, 0] => k * 5, [-1, 0] => (k * 5) + 4, [0, 1] => k, [0, -1] => 20 + k }[[dx, dy]] }
      edge.map { [depth + 1, it] }
    else
      [[depth, (ny * 5) + nx]]
    end
  end
end

def solve2(input, minutes: 200)
  alive = bugs(input).to_set { [0, it] }
  cache = Hash.new { |h, k| h[k] = recursive_neighbours(*k) }
  minutes.times do
    counts = Hash.new(0)
    alive.each { |cell| cache[cell].each { counts[it] += 1 } }
    alive = counts.filter_map { |cell, n| cell if lives?(alive.include?(cell), n) }.to_set
  end
  alive.size
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    ....#
    #..#.
    #..##
    ..#..
    #....
  INPUT

  def test_solve_example
    assert_equal 2_129_920, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 24_662_545, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 99, solve2(EXAMPLE, minutes: 10)
    assert_equal 4, recursive_neighbours(0, 18).size
    assert_equal 8, recursive_neighbours(0, 13).size
  end

  def test_solve2_input
    assert_equal 2063, solve2(read_file('input.txt'))
  end
end
