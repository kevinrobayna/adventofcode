# frozen_string_literal: true

require_relative '../../lib/aoc'

def moons(input)
  input.lines.map { it.scan(/-?\d+/).map(&:to_i) }
end

# Simulates one axis: positions and velocities arrays, mutated in place.
def step_axis(pos, vel)
  pos.each_index do |i|
    pos.each { |p| vel[i] += p <=> pos[i] }
  end
  vel.each_with_index { |v, i| pos[i] += v }
end

def solve(input, steps: 1000)
  axes = moons(input).transpose.map { |pos| [pos, Array.new(pos.size, 0)] }
  steps.times { axes.each { |pos, vel| step_axis(pos, vel) } }
  pos = axes.map(&:first).transpose
  vel = axes.map(&:last).transpose
  pos.zip(vel).sum { |p, v| p.sum(&:abs) * v.sum(&:abs) }
end

def axis_period(start)
  pos = start.dup
  vel = Array.new(pos.size, 0)
  steps = 0
  loop do
    step_axis(pos, vel)
    steps += 1
    return steps if pos == start && vel.all?(&:zero?)
  end
end

def solve2(input)
  moons(input).transpose.map { axis_period(it) }.reduce(:lcm)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    <x=-1, y=0, z=2>
    <x=2, y=-10, z=-7>
    <x=4, y=-8, z=8>
    <x=3, y=5, z=-1>
  INPUT
  EXAMPLE2 = <<~INPUT
    <x=-8, y=-10, z=0>
    <x=5, y=5, z=10>
    <x=2, y=-7, z=3>
    <x=9, y=-8, z=-3>
  INPUT

  def test_solve_example
    assert_equal 179, solve(EXAMPLE, steps: 10)
    assert_equal 1940, solve(EXAMPLE2, steps: 100)
  end

  def test_solve_input
    assert_equal 11_384, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 2772, solve2(EXAMPLE)
    assert_equal 4_686_774_924, solve2(EXAMPLE2)
  end

  def test_solve2_input
    assert_equal 452_582_583_272_768, solve2(read_file('input.txt'))
  end
end
