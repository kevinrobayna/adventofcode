# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

# Returns a list of [generator_floor, microchip_floor] pairs, floors 0..3.
def parse(input)
  gens = {}
  chips = {}
  input.lines.each_with_index do |line, floor|
    line.scan(/(\w+) generator/).flatten.each { |e| gens[e] = floor }
    line.scan(/(\w+)-compatible microchip/).flatten.each { |e| chips[e] = floor }
  end
  gens.keys.map { |e| [gens[e], chips[e]] }
end

def safe?(pairs)
  pairs.all? { |gen, chip| gen == chip || pairs.none? { |g, _| g == chip } }
end

# BFS over states; pairs are interchangeable, so states are kept as sorted pair lists.
def min_steps(pairs)
  start = [0, pairs.sort]
  seen = Set[start]
  frontier = [start]
  steps = 0
  until frontier.empty?
    return steps if frontier.any? { |_, ps| ps.flatten.all?(3) }

    steps += 1
    frontier = frontier.flat_map do |floor, ps|
      items = []
      ps.each_with_index do |(g, c), i|
        items << [i, 0] if g == floor
        items << [i, 1] if c == floor
      end
      loads = items.combination(2).to_a + items.map { |it| [it] }
      [floor - 1, floor + 1].select { |f| f.between?(0, 3) }.flat_map do |to|
        loads.filter_map do |load|
          moved = ps.map(&:dup)
          load.each { |i, k| moved[i][k] = to }
          next unless safe?(moved)

          state = [to, moved.sort]
          state if seen.add?(state)
        end
      end
    end
  end
end

def solve(input)
  min_steps(parse(input))
end

def solve2(input)
  min_steps(parse(input) + [[0, 0], [0, 0]])
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    The first floor contains a hydrogen-compatible microchip and a lithium-compatible microchip.
    The second floor contains a hydrogen generator.
    The third floor contains a lithium generator.
    The fourth floor contains nothing relevant.
  INPUT

  def test_solve_example
    assert_equal 11, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 47, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 15, solve2("The first floor contains nothing relevant.\n")
  end

  def test_solve2_input
    assert_equal 71, solve2(read_file('input.txt'))
  end
end
