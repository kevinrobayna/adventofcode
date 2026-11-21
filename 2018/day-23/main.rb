# frozen_string_literal: true

require_relative '../../lib/aoc'

def nanobots(input)
  input.lines.map { |l| l.scan(/-?\d+/).map(&:to_i) }
end

def manhattan(a, b)
  (a[0] - b[0]).abs + (a[1] - b[1]).abs + (a[2] - b[2]).abs
end

def solve(input)
  bots = nanobots(input)
  strongest = bots.max_by(&:last)
  bots.count { |b| manhattan(b, strongest) <= strongest[3] }
end

# Distance from a point to an axis-aligned cube [lo, lo + size) along each axis.
def box_distance(point, lo, size)
  (0..2).sum do |i|
    hi = lo[i] + size - 1
    if point[i] < lo[i] then lo[i] - point[i]
    elsif point[i] > hi then point[i] - hi
    else 0
    end
  end
end

# Best-first search over subdivided cubes: most bots in range, then closest to origin, then smallest.
def solve2(input)
  bots = nanobots(input)
  coords = bots.flat_map { |x, y, z, _| [x, y, z] }
  size = 1
  size *= 2 while size < coords.map(&:abs).max * 2
  lo = [-size / 2] * 3
  count = ->(l, s) { bots.count { |b| box_distance(b, l, s) <= b[3] } }
  key = ->(l, s) { [-count.call(l, s), box_distance([0, 0, 0], l, s), s] }
  queue = [[key.call(lo, size), lo, size]]
  until queue.empty?
    k, l, s = queue.shift
    return k[1] if s == 1

    half = s / 2
    [0, half].product([0, half], [0, half]).each do |dx, dy, dz|
      nl = [l[0] + dx, l[1] + dy, l[2] + dz]
      entry = [key.call(nl, half), nl, half]
      idx = queue.bsearch_index { |e| (e[0] <=> entry[0]) >= 0 } || queue.size
      queue.insert(idx, entry)
    end
  end
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    pos=<0,0,0>, r=4
    pos=<1,0,0>, r=1
    pos=<4,0,0>, r=3
    pos=<0,2,0>, r=1
    pos=<0,5,0>, r=3
    pos=<0,0,3>, r=1
    pos=<1,1,1>, r=1
    pos=<1,1,2>, r=1
    pos=<1,3,1>, r=1
  INPUT

  EXAMPLE2 = <<~INPUT
    pos=<10,12,12>, r=2
    pos=<12,14,12>, r=2
    pos=<16,12,12>, r=4
    pos=<14,14,14>, r=6
    pos=<50,50,50>, r=200
    pos=<10,10,10>, r=5
  INPUT

  def test_solve_example
    assert_equal 7, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 309, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 36, solve2(EXAMPLE2)
  end

  def test_solve2_input
    assert_equal 119_011_326, solve2(read_file('input.txt'))
  end
end
