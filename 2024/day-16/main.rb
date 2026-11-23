# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

DIRS = [[0, 1], [1, 0], [0, -1], [-1, 0]].freeze # east first: the reindeer starts facing east

# Minimal binary heap of [cost, payload] pairs.
class MinHeap
  def initialize
    @items = []
  end

  def empty?
    @items.empty?
  end

  def push(item)
    @items << item
    i = @items.size - 1
    while i.positive?
      parent = (i - 1) / 2
      break if (@items[parent][0] <=> item[0]) <= 0

      @items[i] = @items[parent]
      i = parent
    end
    @items[i] = item
  end

  def pop
    top = @items.first
    last = @items.pop
    return top if @items.empty?

    i = 0
    loop do
      child = (2 * i) + 1
      break if child >= @items.size

      child += 1 if child + 1 < @items.size && @items[child + 1][0] < @items[child][0]
      break if last[0] <= @items[child][0]

      @items[i] = @items[child]
      i = child
    end
    @items[i] = last
    top
  end
end

def parse(input)
  grid = input.lines.map(&:chomp)
  find = ->(ch) { grid.each_with_index { |row, r| (c = row.index(ch)) && (return [r, c]) } }
  [grid, find.call('S'), find.call('E')]
end

# Dijkstra over (row, col, dir) states. Moving forward costs 1, turning 90 degrees costs 1000.
# With `reverse`, steps go backwards so distances are "cost to reach `starts`".
def dijkstra(grid, starts, reverse: false)
  dist = {}
  heap = MinHeap.new
  starts.each { heap.push([0, _1]) }
  until heap.empty?
    cost, state = heap.pop
    next if dist.key?(state)

    dist[state] = cost
    r, c, d = state
    dr, dc = DIRS[d]
    if reverse
      dr = -dr
      dc = -dc
    end
    heap.push([cost + 1, [r + dr, c + dc, d]]) unless grid[r + dr][c + dc] == '#'
    heap.push([cost + 1000, [r, c, (d + 1) % 4]])
    heap.push([cost + 1000, [r, c, (d + 3) % 4]])
  end
  dist
end

def best_score(from_start, finish)
  4.times.filter_map { from_start[[*finish, _1]] }.min
end

def solve(input)
  grid, start, finish = parse(input)
  best_score(dijkstra(grid, [[*start, 0]]), finish)
end

def solve2(input)
  grid, start, finish = parse(input)
  from_start = dijkstra(grid, [[*start, 0]])
  best = best_score(from_start, finish)
  ends = Array.new(4) { [*finish, _1] }.select { from_start[_1] == best }
  to_end = dijkstra(grid, ends, reverse: true)
  from_start.select { |state, cost| to_end[state] && cost + to_end[state] == best }.keys.map { _1[0, 2] }.uniq.size
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    ###############
    #.......#....E#
    #.#.###.#.###.#
    #.....#.#...#.#
    #.###.#####.#.#
    #.#.#.......#.#
    #.#.#####.###.#
    #...........#.#
    ###.#.#####.#.#
    #...#.....#.#.#
    #.#.#.###.#.#.#
    #.....#...#.#.#
    #.###.#.#.#.#.#
    #S..#.....#...#
    ###############
  INPUT

  EXAMPLE2 = <<~INPUT
    #################
    #...#...#...#..E#
    #.#.#.#.#.#.#.#.#
    #.#.#.#...#...#.#
    #.#.#.#.###.#.#.#
    #...#.#.#.....#.#
    #.#.#.#.#.#####.#
    #.#...#.#.#.....#
    #.#.#####.#.###.#
    #.#.#.......#...#
    #.#.###.#####.###
    #.#.#...#.....#.#
    #.#.#.#####.###.#
    #.#.#.........#.#
    #.#.#.#########.#
    #S#.............#
    #################
  INPUT

  def test_solve_example
    assert_equal 7036, solve(EXAMPLE)
    assert_equal 11_048, solve(EXAMPLE2)
  end

  def test_solve2_example
    assert_equal 45, solve2(EXAMPLE)
    assert_equal 64, solve2(EXAMPLE2)
  end

  def test_solve_input
    assert_equal 115_500, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 679, solve2(read_file('input.txt'))
  end
end
