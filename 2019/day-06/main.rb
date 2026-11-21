# frozen_string_literal: true

require_relative '../../lib/aoc'

def parents(input)
  input.split.to_h { it.split(')').reverse }
end

def ancestors(parents, node)
  path = []
  path << node while (node = parents[node])
  path
end

def solve(input)
  map = parents(input)
  map.keys.sum { ancestors(map, it).size }
end

def solve2(input)
  map = parents(input)
  you = ancestors(map, 'YOU')
  san = ancestors(map, 'SAN')
  common = (you & san).first
  you.index(common) + san.index(common)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    COM)B
    B)C
    C)D
    D)E
    E)F
    B)G
    G)H
    D)I
    E)J
    J)K
    K)L
  INPUT

  def test_solve_example
    assert_equal 42, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 417_916, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 4, solve2(EXAMPLE + "K)YOU\nI)SAN\n")
  end

  def test_solve2_input
    assert_equal 523, solve2(read_file('input.txt'))
  end
end
