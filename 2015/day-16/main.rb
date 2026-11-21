# frozen_string_literal: true

require_relative '../../lib/aoc'

TICKER = {
  'children' => 3, 'cats' => 7, 'samoyeds' => 2, 'pomeranians' => 3, 'akitas' => 0,
  'vizslas' => 0, 'goldfish' => 5, 'trees' => 3, 'cars' => 2, 'perfumes' => 1
}.freeze

RANGES = {
  'cats' => :>, 'trees' => :>, 'pomeranians' => :<, 'goldfish' => :<
}.freeze

def parse_sues(input)
  input.lines.to_h do |line|
    id = line[/Sue (\d+)/, 1].to_i
    [id, line.scan(/(\w+): (\d+)/).to_h { |k, v| [k, v.to_i] }]
  end
end

def find_sue(input, comparisons = {})
  parse_sues(input).find do |_, things|
    things.all? { |thing, n| n.public_send(comparisons.fetch(thing, :==), TICKER.fetch(thing)) }
  end&.first
end

def solve(input)
  find_sue(input)
end

def solve2(input)
  find_sue(input, RANGES)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    Sue 1: children: 1, cars: 8, vizslas: 7
    Sue 2: cats: 7, trees: 3, goldfish: 5
    Sue 3: cats: 8, trees: 4, goldfish: 4
  INPUT

  def test_solve_example
    assert_equal 2, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 213, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 3, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 323, solve2(read_file('input.txt'))
  end
end
