# frozen_string_literal: true

require_relative '../../lib/aoc'

# Walks the beams down the manifold; returns [split count, timelines per exit column].
def simulate(input)
  rows = input.split
  beams = Hash.new(0)
  beams[rows.first.index('S')] = 1
  splits = 0
  rows.drop(1).each do |row|
    beams = beams.each_with_object(Hash.new(0)) do |(col, count), nxt|
      if row[col] == '^'
        splits += 1
        nxt[col - 1] += count
        nxt[col + 1] += count
      else
        nxt[col] += count
      end
    end
  end
  [splits, beams]
end

def solve(input)
  simulate(input).first
end

def solve2(input)
  simulate(input).last.values.sum
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    .......S.......
    ...............
    .......^.......
    ...............
    ......^.^......
    ...............
    .....^.^.^.....
    ...............
    ....^.^...^....
    ...............
    ...^.^...^.^...
    ...............
    ..^...^.....^..
    ...............
    .^.^.^.^.^...^.
    ...............
  INPUT

  def test_solve_example
    assert_equal 21, solve(EXAMPLE)
  end

  def test_solve2_example
    assert_equal 40, solve2(EXAMPLE)
  end
end
