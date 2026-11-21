# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def asteroids(input)
  input.lines.each_with_index.flat_map do |line, y|
    line.chomp.chars.each_index.select { line[it] == '#' }.map { |x| [x, y] }
  end
end

def direction(from, to)
  dx = to[0] - from[0]
  dy = to[1] - from[1]
  g = dx.gcd(dy)
  [dx / g, dy / g]
end

def best_station(rocks)
  rocks.map { |a| [a, (rocks - [a]).map { direction(a, it) }.uniq.size] }.max_by(&:last)
end

def solve(input)
  best_station(asteroids(input)).last
end

# Angle measured clockwise from "up" (negative y), in [0, 2*PI).
def laser_angle(dx, dy) = Math.atan2(dx, -dy) % (2 * Math::PI)

def vaporization_order(rocks)
  station = best_station(rocks).first
  lines = (rocks - [station]).group_by { direction(station, it) }
  queues = lines.sort_by { |(dx, dy), _| laser_angle(dx, dy) }.map do |_, targets|
    targets.sort_by { (it[0] - station[0]).abs + (it[1] - station[1]).abs }
  end
  order = []
  order.concat(queues.filter_map(&:shift)) until queues.all?(&:empty?)
  order
end

def solve2(input, nth: 200)
  x, y = vaporization_order(asteroids(input))[nth - 1]
  (x * 100) + y
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    .#..#
    .....
    #####
    ....#
    ...##
  INPUT

  LARGE = <<~INPUT
    .#..##.###...#######
    ##.############..##.
    .#.######.########.#
    .###.#######.####.#.
    #####.##.#.##.###.##
    ..#####..#.#########
    ####################
    #.####....###.#.#.##
    ##.#################
    #####.##.###..####..
    ..######..##.#######
    ####.##.####...##..#
    .#####..#.######.###
    ##...#.##########...
    #.##########.#######
    .####.#.###.###.#.##
    ....##.##.###..#####
    .#.#.###########.###
    #.#.#.#####.####.###
    ###.##.####.##.#..##
  INPUT

  def test_solve_example
    assert_equal 8, solve(EXAMPLE)
    assert_equal [[11, 13], 210], best_station(asteroids(LARGE))
  end

  def test_solve_input
    assert_equal 276, solve(read_file('input.txt'))
  end

  def test_solve2_example
    order = vaporization_order(asteroids(LARGE))

    assert_equal [[11, 12], [12, 1], [12, 2]], order.first(3)
    assert_equal [10, 16], order[99]
    assert_equal [11, 1], order.last
    assert_equal 802, solve2(LARGE)
  end

  def test_solve2_input
    assert_equal 1321, solve2(read_file('input.txt'))
  end
end
