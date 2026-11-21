# frozen_string_literal: true

require_relative '../../lib/aoc'

def parse(input)
  directions, *words = input.scan(/\w+/)
  nodes = words.each_slice(3).to_h { |source, left, right| [source, { 'L' => left, 'R' => right }] }
  [directions, nodes]
end

def steps(directions, nodes, node)
  count = 0
  until yield(node)
    node = nodes[node][directions[count % directions.length]]
    count += 1
  end
  count
end

def solve(input)
  directions, nodes = parse(input)
  steps(directions, nodes, 'AAA') { it == 'ZZZ' }
end

# Each ghost reaches a Z node on a cycle, so the answer is the LCM of the first arrival times.
def solve2(input)
  directions, nodes = parse(input)
  nodes.keys.select { it.end_with?('A') }
       .map { |start| steps(directions, nodes, start) { it.end_with?('Z') } }
       .reduce(1, :lcm)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    RL

    AAA = (BBB, CCC)
    BBB = (DDD, EEE)
    CCC = (ZZZ, GGG)
    DDD = (DDD, DDD)
    EEE = (EEE, EEE)
    GGG = (GGG, GGG)
    ZZZ = (ZZZ, ZZZ)
  INPUT

  EXAMPLE2 = <<~INPUT
    LLR

    AAA = (BBB, BBB)
    BBB = (AAA, ZZZ)
    ZZZ = (ZZZ, ZZZ)
  INPUT

  EXAMPLE3 = <<~INPUT
    LR

    11A = (11B, XXX)
    11B = (XXX, 11Z)
    11Z = (11B, XXX)
    22A = (22B, XXX)
    22B = (22C, 22C)
    22C = (22Z, 22Z)
    22Z = (22B, 22B)
    XXX = (XXX, XXX)
  INPUT

  def test_solve_example
    assert_equal 2, solve(EXAMPLE)
    assert_equal 6, solve(EXAMPLE2)
  end

  def test_solve_input
    assert_equal 16_409, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 2, solve2(EXAMPLE)
    assert_equal 6, solve2(EXAMPLE2)
    assert_equal 6, solve2(EXAMPLE3)
  end

  def test_solve2_input
    assert_equal 11_795_205_644_011, solve2(read_file('input.txt'))
  end
end
