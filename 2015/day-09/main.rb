# frozen_string_literal: true

require_relative '../../lib/aoc'

def route_lengths(input)
  distances = Hash.new { |h, k| h[k] = {} }
  input.scan(/(\w+) to (\w+) = (\d+)/).each do |a, b, d|
    distances[a][b] = distances[b][a] = d.to_i
  end
  distances.keys.permutation.map do |route|
    route.each_cons(2).sum { |a, b| distances[a][b] }
  end
end

def solve(input)
  route_lengths(input).min
end

def solve2(input)
  route_lengths(input).max
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    London to Dublin = 464
    London to Belfast = 518
    Dublin to Belfast = 141
  INPUT

  def test_solve_example
    assert_equal 605, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 251, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 982, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 898, solve2(read_file('input.txt'))
  end
end
