# frozen_string_literal: true

require_relative '../../lib/aoc'

def parse_pots(input)
  initial, *rules = input.lines(chomp: true).reject(&:empty?)
  state = initial.split(': ').last
  plants = state.chars.each_index.select { |i| state[i] == '#' }.to_set
  growing = rules.filter_map { |r| r[0, 5] if r.end_with?('#') }.to_set
  [plants, growing]
end

def step(plants, growing)
  min, max = plants.minmax
  ((min - 2)..(max + 2)).select do |i|
    growing.include?(((i - 2)..(i + 2)).map { |j| plants.include?(j) ? '#' : '.' }.join)
  end.to_set
end

def solve(input, generations: 20)
  plants, growing = parse_pots(input)
  gen = 0
  while gen < generations
    nxt = step(plants, growing)
    gen += 1
    # Once the pattern just shifts, the sum grows linearly.
    return nxt.sum + ((generations - gen) * (nxt.sum - plants.sum)) if nxt.map { |i| i - nxt.min } == plants.map { |i| i - plants.min }

    plants = nxt
  end
  plants.sum
end

def solve2(input)
  solve(input, generations: 50_000_000_000)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    initial state: #..#.#..##......###...###

    ...## => #
    ..#.. => #
    .#... => #
    .#.#. => #
    .#.## => #
    .##.. => #
    .#### => #
    #.#.# => #
    #.### => #
    ##.#. => #
    ##.## => #
    ###.. => #
    ###.# => #
    ####. => #
  INPUT

  def test_solve_example
    assert_equal 325, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 2045, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 2_100_000_000_428, solve2(read_file('input.txt'))
  end
end
