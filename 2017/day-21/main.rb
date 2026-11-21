# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

START = %w[.#. ..# ###].freeze

def variants(grid)
  rotations = [grid]
  3.times { rotations << rotations.last.map(&:chars).transpose.map(&:reverse).map(&:join) }
  rotations + rotations.map { |g| g.map(&:reverse) }
end

def parse_rules(input)
  input.lines.each_with_object({}) do |line, rules|
    from, to = line.strip.split(' => ')
    next unless to

    variants(from.split('/')).each { |v| rules[v] = to.split('/') }
  end
end

def enhance(grid, rules)
  size = grid.size.even? ? 2 : 3
  (0...grid.size).step(size).flat_map do |y|
    blocks = (0...grid.size).step(size).map { |x| rules.fetch(grid[y, size].map { |r| r[x, size] }) }
    blocks.transpose.map(&:join)
  end
end

# Every 3 iterations a 3x3 block becomes a 9x9 grid of nine independent 3x3 blocks, so counts can be memoized.
def count_on(grid, iterations, rules, memo = {})
  memo[[grid, iterations]] ||=
    if iterations < 3 || grid.size != 3
      iterations.times { grid = enhance(grid, rules) }
      grid.sum { |r| r.count('#') }
    else
      big = 3.times.reduce(grid) { |g, _| enhance(g, rules) }
      [0, 3, 6].product([0, 3, 6]).sum do |y, x|
        count_on(big[y, 3].map { |r| r[x, 3] }, iterations - 3, rules, memo)
      end
    end
end

def solve(input, iterations: 5)
  count_on(START, iterations, parse_rules(input))
end

def solve2(input)
  solve(input, iterations: 18)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    ../.# => ##./#../...
    .#./..#/### => #..#/..../..../#..#
  INPUT

  def test_solve_example
    assert_equal 12, solve(EXAMPLE, iterations: 2)
  end

  def test_solve_input
    assert_equal 162, solve(read_file('input.txt'))
  end

  def test_solve2_example
    # Part 2 only changes the iteration count; check memoized path agrees with brute force.
    rules = parse_rules(read_file('input.txt'))
    grid = START
    7.times { grid = enhance(grid, rules) }
    assert_equal grid.sum { |r| r.count('#') }, count_on(START, 7, rules)
  end

  def test_solve2_input
    assert_equal 2_264_586, solve2(read_file('input.txt'))
  end
end
