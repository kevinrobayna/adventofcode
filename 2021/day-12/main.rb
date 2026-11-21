# frozen_string_literal: true

require_relative '../../lib/aoc'

def parse(input)
  graph = Hash.new { |h, k| h[k] = [] }
  input.split("\n").each do |line|
    a, b = line.split('-')
    graph[a] << b unless b == 'start'
    graph[b] << a unless a == 'start'
  end
  graph
end

def count_paths(graph, cave, visited, twice_allowed)
  return 1 if cave == 'end'

  graph[cave].sum do |nxt|
    small = nxt == nxt.downcase
    if !small || !visited.include?(nxt)
      count_paths(graph, nxt, small ? visited + [nxt] : visited, twice_allowed)
    elsif twice_allowed
      count_paths(graph, nxt, visited, false)
    else
      0
    end
  end
end

def solve(input)
  count_paths(parse(input), 'start', ['start'], false)
end

def solve2(input)
  count_paths(parse(input), 'start', ['start'], true)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    start-A
    start-b
    A-c
    A-b
    b-d
    A-end
    b-end
  INPUT

  EXAMPLE2 = <<~INPUT
    dc-end
    HN-start
    start-kj
    dc-start
    dc-HN
    LN-dc
    HN-end
    kj-sa
    kj-HN
    kj-dc
  INPUT

  EXAMPLE3 = <<~INPUT
    fs-end
    he-DX
    fs-he
    start-DX
    pj-DX
    end-zg
    zg-sl
    zg-pj
    pj-he
    RW-he
    fs-DX
    pj-RW
    zg-RW
    start-pj
    he-WI
    zg-he
    pj-fs
    start-RW
  INPUT

  def test_solve_example
    assert_equal 10, solve(EXAMPLE)
    assert_equal 19, solve(EXAMPLE2)
    assert_equal 226, solve(EXAMPLE3)
  end

  def test_solve_input
    assert_equal 4411, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 36, solve2(EXAMPLE)
    assert_equal 103, solve2(EXAMPLE2)
    assert_equal 3509, solve2(EXAMPLE3)
  end

  def test_solve2_input
    assert_equal 136_767, solve2(read_file('input.txt'))
  end
end
