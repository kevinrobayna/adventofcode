# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def parse(input)
  graph = Hash.new { |h, k| h[k] = Set.new }
  input.split.each do |edge|
    a, b = edge.split('-')
    graph[a] << b
    graph[b] << a
  end
  graph
end

def solve(input)
  graph = parse(input)
  triangles = Set.new
  graph.each do |a, neighbours|
    next unless a.start_with?('t')

    neighbours.to_a.combination(2) do |b, c|
      triangles << [a, b, c].sort if graph[b].include?(c)
    end
  end
  triangles.size
end

# Bron-Kerbosch with pivoting; yields every maximal clique.
def bron_kerbosch(graph, r, p, x, &block)
  return yield(r) if p.empty? && x.empty?

  pivot = (p | x).max_by { graph[_1].size }
  (p - graph[pivot]).each do |v|
    bron_kerbosch(graph, r + [v], p & graph[v], x & graph[v], &block)
    p.delete(v)
    x << v
  end
end

def solve2(input)
  graph = parse(input)
  best = []
  bron_kerbosch(graph, [], Set.new(graph.keys), Set.new) { |clique| best = clique if clique.size > best.size }
  best.sort.join(',')
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    kh-tc
    qp-kh
    de-cg
    ka-co
    yn-aq
    qp-ub
    cg-tb
    vc-aq
    tb-ka
    wh-tc
    yn-cg
    kh-ub
    ta-co
    de-co
    tc-td
    tb-wq
    wh-td
    ta-ka
    td-qp
    aq-cg
    wq-ub
    ub-vc
    de-ta
    wq-aq
    wq-vc
    wh-yn
    ka-de
    kh-ta
    co-tc
    wh-qp
    tb-vc
    td-yn
  INPUT

  def test_solve_example
    assert_equal 7, solve(EXAMPLE)
  end

  def test_solve2_example
    assert_equal 'co,de,ka,ta', solve2(EXAMPLE)
  end

  def test_solve_input
    assert_equal 1411, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 'aq,bn,ch,dt,gu,ow,pk,qy,tv,us,yx,zg,zu', solve2(read_file('input.txt'))
  end
end
