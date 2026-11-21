# frozen_string_literal: true

require_relative '../../lib/aoc'

def parse(input)
  graph = Hash.new { |h, k| h[k] = [] }
  input.each_line do |line|
    from, *tos = line.scan(/\w+/)
    tos.each do |to|
      graph[from] << to
      graph[to] << from
    end
  end
  graph
end

# Unit-capacity max flow (Edmonds-Karp) from source to sink, stopping once it exceeds `limit`.
# Returns [flow, nodes reachable from source in the residual graph].
def max_flow(graph, source, sink, limit)
  flow = Hash.new(0)
  total = 0
  loop do
    parent = { source => nil }
    queue = [source]
    until queue.empty? || parent.key?(sink)
      node = queue.shift
      graph[node].each do |nxt|
        next if parent.key?(nxt) || flow[[node, nxt]] >= 1

        parent[nxt] = node
        queue << nxt
      end
    end
    return [total, parent.keys] unless parent.key?(sink)

    total += 1
    return [total, nil] if total > limit

    node = sink
    while (prev = parent[node])
      flow[[prev, node]] += 1
      flow[[node, prev]] -= 1
      node = prev
    end
  end
end

# The graph splits in two by cutting exactly 3 wires: find a sink whose max flow from a fixed
# source is 3; the residual-reachable side is one of the two groups.
def solve(input, cut: 3)
  graph = parse(input)
  source, *others = graph.keys
  others.each do |sink|
    flow, side = max_flow(graph, source, sink, cut)
    return side.size * (graph.size - side.size) if flow == cut
  end
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    jqt: rhn xhk nvd
    rsh: frs pzl lsr
    xhk: hfx
    cmg: qnr nvd lhk bvb
    rhn: xhk bvb hfx
    bvb: xhk hfx
    pzl: lsr hfx nvd
    qnr: nvd
    ntq: jqt hfx bvb xhk
    nvd: lhk
    lsr: lhk
    rzs: qnr cmg lsr rsh
    frs: qnr lhk lsr
  INPUT

  def test_solve_example
    assert_equal 54, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 589_036, solve(read_file('input.txt'))
  end
end
