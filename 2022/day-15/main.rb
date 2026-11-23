# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

Sensor = Struct.new(:x, :y, :bx, :by) do
  def radius
    (x - bx).abs + (y - by).abs
  end

  def covers?(px, py)
    (x - px).abs + (y - py).abs <= radius
  end
end

def parse_sensors(input)
  input.each_line.map { |line| Sensor.new(*line.scan(/-?\d+/).map(&:to_i)) }
end

def merge_ranges(ranges)
  ranges.sort_by(&:first).each_with_object([]) do |(lo, hi), merged|
    if merged.any? && lo <= merged.last[1] + 1
      merged.last[1] = [merged.last[1], hi].max
    else
      merged << [lo, hi]
    end
  end
end

def solve(input, row: 2_000_000)
  sensors = parse_sensors(input)
  ranges = sensors.filter_map do |s|
    width = s.radius - (s.y - row).abs
    [s.x - width, s.x + width] unless width.negative?
  end
  covered = merge_ranges(ranges).sum { |lo, hi| hi - lo + 1 }
  beacons = sensors.select { |s| s.by == row }.map(&:bx).uniq.size
  covered - beacons
end

# The single uncovered point must lie just outside the edge of several sensors, so it sits at
# the intersection of an x+y line and an x-y line taken from those sensor boundaries.
def solve2(input, max: 4_000_000)
  sensors = parse_sensors(input)
  sums = sensors.flat_map { |s| [s.x + s.y + s.radius + 1, s.x + s.y - s.radius - 1] }.uniq
  diffs = sensors.flat_map { |s| [s.x - s.y + s.radius + 1, s.x - s.y - s.radius - 1] }.uniq
  sums.product(diffs).each do |a, b|
    next if (a + b).odd?

    x = (a + b) / 2
    y = (a - b) / 2
    next unless x.between?(0, max) && y.between?(0, max)
    return (x * 4_000_000) + y if sensors.none? { |s| s.covers?(x, y) }
  end
  raise 'No position found'
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    Sensor at x=2, y=18: closest beacon is at x=-2, y=15
    Sensor at x=9, y=16: closest beacon is at x=10, y=16
    Sensor at x=13, y=2: closest beacon is at x=15, y=3
    Sensor at x=12, y=14: closest beacon is at x=10, y=16
    Sensor at x=10, y=20: closest beacon is at x=10, y=16
    Sensor at x=14, y=17: closest beacon is at x=10, y=16
    Sensor at x=8, y=7: closest beacon is at x=2, y=10
    Sensor at x=2, y=0: closest beacon is at x=2, y=10
    Sensor at x=0, y=11: closest beacon is at x=2, y=10
    Sensor at x=20, y=14: closest beacon is at x=25, y=17
    Sensor at x=17, y=20: closest beacon is at x=21, y=22
    Sensor at x=16, y=7: closest beacon is at x=15, y=3
    Sensor at x=14, y=3: closest beacon is at x=15, y=3
    Sensor at x=20, y=1: closest beacon is at x=15, y=3
  INPUT

  def test_solve_example
    assert_equal 26, solve(EXAMPLE, row: 10)
  end

  def test_solve_input
    assert_equal 4_873_353, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 56_000_011, solve2(EXAMPLE, max: 20)
  end

  def test_solve2_input
    assert_equal 11_600_823_139_120, solve2(read_file('input.txt'))
  end
end
