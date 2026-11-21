# frozen_string_literal: true

require_relative '../../lib/aoc'

def parse(input)
  input.lines.map { _1.scan(/-?\d+/).map(&:to_i) }
end

def solve(input, width: 101, height: 103, seconds: 100)
  quadrants = Hash.new(0)
  parse(input).each do |px, py, vx, vy|
    x = (px + (vx * seconds)) % width
    y = (py + (vy * seconds)) % height
    next if x == width / 2 || y == height / 2

    quadrants[[x < width / 2, y < height / 2]] += 1
  end
  quadrants.values.reduce(1, :*)
end

def variance(values)
  mean = values.sum.fdiv(values.size)
  values.sum { (_1 - mean)**2 }
end

# The tree appears when the robots are clustered; x repeats every `width` seconds and y every
# `height` seconds, so find the tightest time for each axis and combine them (CRT).
def solve2(input, width: 101, height: 103)
  robots = parse(input)
  best_x = (0...width).min_by { |t| variance(robots.map { |px, _, vx, _| (px + (vx * t)) % width }) }
  best_y = (0...height).min_by { |t| variance(robots.map { |_, py, _, vy| (py + (vy * t)) % height }) }
  best_x.step(width * height, width).find { (_1 % height) == best_y }
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    p=0,4 v=3,-3
    p=6,3 v=-1,-3
    p=10,3 v=-1,2
    p=2,0 v=2,-1
    p=0,0 v=1,3
    p=3,0 v=-2,-2
    p=7,6 v=-1,-3
    p=3,0 v=-1,-2
    p=9,3 v=2,3
    p=7,3 v=-1,2
    p=2,4 v=2,-3
    p=9,5 v=-3,-3
  INPUT

  def test_solve_example
    assert_equal 12, solve(EXAMPLE, width: 11, height: 7)
  end

  # Builds robots that all land inside a small square at second `target`, plus random noise.
  def test_solve2_clustered_robots
    rng = Random.new(42)
    target = 6_789
    lines = Array.new(300) do |i|
      vx = rng.rand(-50..50)
      vy = rng.rand(-50..50)
      if i < 200
        x = 40 + rng.rand(20)
        y = 40 + rng.rand(20)
        px = (x - (vx * target)) % 101
        py = (y - (vy * target)) % 103
      else
        px = rng.rand(101)
        py = rng.rand(103)
      end
      "p=#{px},#{py} v=#{vx},#{vy}"
    end
    assert_equal target, solve2(lines.join("\n"))
  end
end
