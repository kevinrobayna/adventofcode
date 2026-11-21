# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

SLOPES = { '>' => [0, 1], '<' => [0, -1], 'v' => [1, 0], '^' => [-1, 0] }.freeze

def open_moves(grid, r, c, slippery)
  dirs = slippery && SLOPES[grid[r][c]] ? [SLOPES[grid[r][c]]] : SLOPES.values
  dirs.filter_map do |dr, dc|
    nr = r + dr
    nc = c + dc
    next if nr.negative? || nr >= grid.length || grid[nr][nc] == '#'

    [nr, nc]
  end
end

# Compresses the maze into a graph of junctions (plus start/end) with corridor lengths as weights.
def junction_graph(grid, slippery)
  start = [0, grid.first.index('.')]
  finish = [grid.length - 1, grid.last.index('.')]
  nodes = [start, finish]
  grid.each_with_index do |row, r|
    row.each_char.with_index do |ch, c|
      nodes << [r, c] if ch != '#' && open_moves(grid, r, c, false).size > 2
    end
  end
  index = nodes.each_with_index.to_h
  edges = Array.new(nodes.size) { [] }
  nodes.each_with_index do |node, i|
    stack = [[node, 0]]
    seen = { node => true }
    until stack.empty?
      pos, dist = stack.pop
      if dist.positive? && index.key?(pos)
        edges[i] << [index[pos], dist]
        next
      end
      open_moves(grid, *pos, slippery).each do |nxt|
        next if seen[nxt]

        seen[nxt] = true
        stack << [nxt, dist + 1]
      end
    end
  end
  edges
end

# DFS over simple paths using a visited bitmask. Once at the junction next to the exit we must
# take the exit (otherwise we could never reach it), which prunes a lot.
def longest_path(edges)
  target = 1
  last = edges.index { |adj| adj.any? { |to, _| to == target } }
  last_dist = edges[last].find { |to, _| to == target }[1]
  best = 0
  stack = [[0, 1, 0]]
  until stack.empty?
    node, visited, dist = stack.pop
    if node == last
      best = dist + last_dist if dist + last_dist > best
      next
    end
    edges[node].each do |to, d|
      bit = 1 << to
      stack << [to, visited | bit, dist + d] if visited.nobits?(bit)
    end
  end
  best
end

def solve(input)
  longest_path(junction_graph(input.lines.map(&:strip), true))
end

def solve2(input)
  longest_path(junction_graph(input.lines.map(&:strip), false))
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    #.#####################
    #.......#########...###
    #######.#########.#.###
    ###.....#.>.>.###.#.###
    ###v#####.#v#.###.#.###
    ###.>...#.#.#.....#...#
    ###v###.#.#.#########.#
    ###...#.#.#.......#...#
    #####.#.#.#######.#.###
    #.....#.#.#.......#...#
    #.#####.#.#.#########v#
    #.#...#...#...###...>.#
    #.#.#v#######v###.###v#
    #...#.>.#...>.>.#.###.#
    #####v#.#.###v#.#.###.#
    #.....#...#...#.#.#...#
    #.#########.###.#.#.###
    #...###...#...#...#.###
    ###.###.#.###v#####v###
    #...#...#.#.>.>.#.>.###
    #.###.###.#.###.#.#v###
    #.....###...###...#...#
    #####################.#
  INPUT

  def test_solve_example
    assert_equal 94, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 2178, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 154, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 6486, solve2(read_file('input.txt'))
  end
end
