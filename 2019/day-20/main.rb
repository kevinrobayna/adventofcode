# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

STEPS = [[1, 0], [-1, 0], [0, 1], [0, -1]].freeze

# Returns open tiles and portals: {pos => [label, outer?]}.
def parse_maze(input)
  rows = input.split("\n")
  width = rows.map(&:size).max
  rows = rows.map { it.ljust(width) }
  at = ->(x, y) { y.between?(0, rows.size - 1) && x.between?(0, width - 1) ? rows[y][x] : ' ' }
  walls = rows.each_with_index.flat_map { |r, y| r.chars.each_index.select { r[it] == '#' }.map { [it, y] } }
  xs = walls.map(&:first).minmax
  ys = walls.map(&:last).minmax
  portals = {}
  rows.each_with_index do |row, y|
    row.chars.each_with_index do |c, x|
      next unless c == '.'

      STEPS.each do |dx, dy|
        a = at.call(x + dx, y + dy)
        next unless a.match?(/[A-Z]/)

        b = at.call(x + (2 * dx), y + (2 * dy))
        label = dx + dy == 1 ? a + b : b + a
        portals[[x, y]] = [label, xs.include?(x) || ys.include?(y)]
      end
    end
  end
  [->(x, y) { at.call(x, y) == '.' }, portals]
end

# Walking distances between portal tiles: {pos => {pos => steps}}.
def portal_graph(open, portals)
  portals.keys.to_h do |start|
    dist = { start => 0 }
    queue = [start]
    until queue.empty?
      x, y = queue.shift
      STEPS.each do |dx, dy|
        nxt = [x + dx, y + dy]
        next if dist.key?(nxt) || !open.call(*nxt)

        dist[nxt] = dist[[x, y]] + 1
        queue << nxt
      end
    end
    [start, dist.slice(*portals.keys).except(start)]
  end
end

def shortest(input, recursive:)
  open, portals = parse_maze(input)
  graph = portal_graph(open, portals)
  find = ->(name) { portals.find { |_, (label, _)| label == name }[0] }
  partner = portals.to_h { |pos, (label, _)| [pos, portals.find { |p, (l, _)| l == label && p != pos }&.first] }
  goal = [find.call('ZZ'), 0]
  max_level = recursive ? portals.size : 0
  best = { [find.call('AA'), 0] => 0 }
  buckets = [[best.keys.first]]
  buckets.each_with_index do |bucket, dist|
    bucket&.each do |state|
      next if best[state] < dist
      return dist if state == goal

      pos, level = state
      moves = graph[pos].map { |p, d| [[p, level], d] }
      if (other = partner[pos])
        nxt_level = if recursive
                      level + (portals[pos][1] ? -1 : 1)
                    else
                      0
                    end
        moves << [[other, nxt_level], 1] if nxt_level.between?(0, max_level)
      end
      moves.each do |nxt, d|
        next if best.fetch(nxt, Float::INFINITY) <= dist + d

        best[nxt] = dist + d
        (buckets[dist + d] ||= []) << nxt
      end
    end
  end
  nil
end

def solve(input)
  shortest(input, recursive: false)
end

def solve2(input)
  shortest(input, recursive: true)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
             A
             A
      #######.#########
      #######.........#
      #######.#######.#
      #######.#######.#
      #######.#######.#
      #####  B    ###.#
    BC...##  C    ###.#
      ##.##       ###.#
      ##...DE  F  ###.#
      #####    G  ###.#
      #########.#####.#
    DE..#######...###.#
      #.#########.###.#
    FG..#########.....#
      ###########.#####
                 Z
                 Z
  INPUT

  EXAMPLE2 = <<~INPUT
                       A
                       A
      #################.#############
      #.#...#...................#.#.#
      #.#.#.###.###.###.#########.#.#
      #.#.#.......#...#.....#.#.#...#
      #.#########.###.#####.#.#.###.#
      #.............#.#.....#.......#
      ###.###########.###.#####.#.#.#
      #.....#        A   C    #.#.#.#
      #######        S   P    #####.#
      #.#...#                 #......VT
      #.#.#.#                 #.#####
      #...#.#               YN....#.#
      #.###.#                 #####.#
    DI....#.#                 #.....#
      #####.#                 #.###.#
    ZZ......#               QG....#..AS
      ###.###                 #######
    JO..#.#.#                 #.....#
      #.#.#.#                 ###.#.#
      #...#..DI             BU....#..LF
      #####.#                 #.#####
    YN......#               VT..#....QG
      #.###.#                 #.###.#
      #.#...#                 #.....#
      ###.###    J L     J    #.#.###
      #.....#    O F     P    #.#...#
      #.###.#####.#.#####.#####.###.#
      #...#.#.#...#.....#.....#.#...#
      #.#####.###.###.#.#.#########.#
      #...#.#.....#...#.#.#.#.....#.#
      #.###.#####.###.###.#.#.#######
      #.#.........#...#.............#
      #########.###.###.#############
               B   J   C
               U   P   P
  INPUT

  def test_solve_example
    assert_equal 23, solve(EXAMPLE)
    assert_equal 58, solve(EXAMPLE2)
  end

  def test_solve_input
    assert_equal 422, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 26, solve2(EXAMPLE)
    assert_nil solve2(EXAMPLE2)
  end

  def test_solve2_input
    assert_equal 5040, solve2(read_file('input.txt'))
  end
end
