# frozen_string_literal: true

require_relative '../../lib/aoc'

def coords(input)
  input.lines.map { |l| l.scan(/\d+/).map(&:to_i) }
end

def bounds(points)
  xs, ys = points.transpose
  [xs.minmax, ys.minmax]
end

def solve(input)
  points = coords(input)
  (x0, x1), (y0, y1) = bounds(points)
  areas = Hash.new(0)
  infinite = Set.new
  (x0..x1).each do |x|
    (y0..y1).each do |y|
      dists = points.map { |px, py| (px - x).abs + (py - y).abs }
      min = dists.min
      next if dists.count(min) > 1

      owner = dists.index(min)
      areas[owner] += 1
      infinite << owner if x == x0 || x == x1 || y == y0 || y == y1
    end
  end
  areas.reject { |k, _| infinite.include?(k) }.values.max
end

def solve2(input, limit: 10_000)
  points = coords(input)
  (x0, x1), (y0, y1) = bounds(points)
  pad = limit / points.size
  ((x0 - pad)..(x1 + pad)).sum do |x|
    dx = points.sum { |px, _| (px - x).abs }
    next 0 if dx >= limit

    ((y0 - pad)..(y1 + pad)).count { |y| dx + points.sum { |_, py| (py - y).abs } < limit }
  end
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    1, 1
    1, 6
    8, 3
    3, 4
    5, 5
    8, 9
  INPUT

  def test_solve_example
    assert_equal 17, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 3238, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 16, solve2(EXAMPLE, limit: 32)
  end

  def test_solve2_input
    assert_equal 45_046, solve2(read_file('input.txt'))
  end
end
