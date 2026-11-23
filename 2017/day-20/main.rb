# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

TICKS = 1000

Particle = Struct.new(:id, :p, :v, :a) do
  def tick
    3.times do |i|
      v[i] += a[i]
      p[i] += v[i]
    end
  end

  def distance = p.sum(&:abs)
end

def parse_particles(input)
  input.lines.each_with_index.map do |line, i|
    nums = line.scan(/-?\d+/).map(&:to_i)
    Particle.new(i, nums[0, 3], nums[3, 3], nums[6, 3])
  end
end

# Long-run closest: smallest acceleration, then velocity, then position (ties broken by simulating).
def solve(input, ticks: TICKS)
  particles = parse_particles(input)
  ticks.times { particles.each(&:tick) }
  particles.min_by { |pt| [pt.a.sum(&:abs), pt.distance] }.id
end

def solve2(input, ticks: TICKS)
  particles = parse_particles(input)
  ticks.times do
    particles.each(&:tick)
    collided = particles.group_by(&:p).values.select { |g| g.size > 1 }.flatten
    particles -= collided
  end
  particles.size
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    p=< 3,0,0>, v=< 2,0,0>, a=<-1,0,0>
    p=< 4,0,0>, v=< 0,0,0>, a=<-2,0,0>
  INPUT

  EXAMPLE2 = <<~INPUT
    p=<-6,0,0>, v=< 3,0,0>, a=< 0,0,0>
    p=<-4,0,0>, v=< 2,0,0>, a=< 0,0,0>
    p=<-2,0,0>, v=< 1,0,0>, a=< 0,0,0>
    p=< 3,0,0>, v=<-1,0,0>, a=< 0,0,0>
  INPUT

  def test_solve_example
    assert_equal 0, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 308, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 1, solve2(EXAMPLE2)
  end

  def test_solve2_input
    assert_equal 504, solve2(read_file('input.txt'))
  end
end
