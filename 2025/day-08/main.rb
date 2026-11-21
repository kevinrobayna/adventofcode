# frozen_string_literal: true

require_relative '../../lib/aoc'

# Minimal union-find tracking component sizes.
class DisjointSet
  attr_reader :components

  def initialize(size)
    @parent = (0...size).to_a
    @size = Array.new(size, 1)
    @components = size
  end

  def find(node)
    @parent[node] = find(@parent[node]) unless @parent[node] == node
    @parent[node]
  end

  def union(a, b)
    a = find(a)
    b = find(b)
    return false if a == b

    a, b = b, a if @size[a] < @size[b]
    @parent[b] = a
    @size[a] += @size[b]
    @components -= 1
    true
  end

  def sizes
    @parent.each_index.select { |i| find(i) == i }.map { |i| @size[i] }
  end
end

def boxes(input)
  input.split.map { |line| line.split(',').map(&:to_i) }
end

def pairs_by_distance(points)
  pairs = []
  points.each_with_index do |(x1, y1, z1), i|
    (i + 1...points.size).each do |j|
      x2, y2, z2 = points[j]
      pairs << [((x1 - x2)**2) + ((y1 - y2)**2) + ((z1 - z2)**2), i, j]
    end
  end
  pairs.sort!
end

def solve(input, connections: 1000)
  points = boxes(input)
  set = DisjointSet.new(points.size)
  pairs_by_distance(points).first(connections).each { |_, i, j| set.union(i, j) }
  set.sizes.max(3).reduce(:*)
end

def solve2(input)
  points = boxes(input)
  set = DisjointSet.new(points.size)
  pairs_by_distance(points).each do |_, i, j|
    return points[i][0] * points[j][0] if set.union(i, j) && set.components == 1
  end
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    162,817,812
    57,618,57
    906,360,560
    592,479,940
    352,342,300
    466,668,158
    542,29,236
    431,825,988
    739,650,466
    52,470,668
    216,146,977
    819,987,18
    117,168,530
    805,96,715
    346,949,466
    970,615,88
    941,993,340
    862,61,35
    984,92,344
    425,690,689
  INPUT

  def test_solve_example
    assert_equal 40, solve(EXAMPLE, connections: 10)
  end

  def test_solve2_example
    assert_equal 25_272, solve2(EXAMPLE)
  end
end
