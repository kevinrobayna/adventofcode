# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

Reindeer = Struct.new(:speed, :fly, :rest) do
  def distance(time)
    full, remainder = time.divmod(fly + rest)
    speed * ((full * fly) + [remainder, fly].min)
  end
end

def parse_reindeer(input)
  input.scan(%r{(\d+) km/s for (\d+) seconds.* (\d+) seconds}).map { |nums| Reindeer.new(*nums.map(&:to_i)) }
end

def solve(input, time: 2503)
  parse_reindeer(input).map { |r| r.distance(time) }.max
end

def solve2(input, time: 2503)
  reindeer = parse_reindeer(input)
  points = Array.new(reindeer.size, 0)
  (1..time).each do |t|
    distances = reindeer.map { |r| r.distance(t) }
    lead = distances.max
    distances.each_with_index { |d, i| points[i] += 1 if d == lead }
  end
  points.max
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.
    Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.
  INPUT

  def test_solve_example
    assert_equal 1120, solve(EXAMPLE, time: 1000)
  end

  def test_solve_input
    assert_equal 2640, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 689, solve2(EXAMPLE, time: 1000)
  end

  def test_solve2_input
    assert_equal 1102, solve2(read_file('input.txt'))
  end
end
