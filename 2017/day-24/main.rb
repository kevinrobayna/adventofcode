# frozen_string_literal: true

require_relative '../../lib/aoc'

# Returns [max strength, [max length, strength of the strongest longest]] of bridges continuing from `port`.
def best_bridges(by_port, port, used)
  best = 0
  longest = [0, 0]
  by_port[port].each do |i, a, b|
    next if used[i]

    used[i] = true
    strength, (len, len_strength) = best_bridges(by_port, a == port ? b : a, used)
    used[i] = false
    best = [best, strength + a + b].max
    longest = [longest, [len + 1, len_strength + a + b]].max
  end
  [best, longest]
end

def bridges(input)
  by_port = Hash.new { |h, k| h[k] = [] }
  input.lines.map { |l| l.split('/').map(&:to_i) }.reject(&:empty?).each_with_index do |(a, b), i|
    by_port[a] << [i, a, b]
    by_port[b] << [i, a, b] unless a == b
  end
  best_bridges(by_port, 0, [])
end

def solve(input)
  bridges(input)[0]
end

def solve2(input)
  bridges(input)[1][1]
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    0/2
    2/2
    2/3
    3/4
    3/5
    0/1
    10/1
    9/10
  INPUT

  def test_solve_example
    assert_equal 31, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 1_511, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 19, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 1_471, solve2(read_file('input.txt'))
  end
end
