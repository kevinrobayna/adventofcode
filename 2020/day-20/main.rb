# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

MONSTER = [
  '                  # ',
  '#    ##    ##    ###',
  ' #  #  #  #  #  #   '
].freeze

def parse(input)
  input.split("\n\n").to_h do |block|
    header, *rows = block.split("\n")
    [header[/\d+/].to_i, rows.map(&:chars)]
  end
end

def orientations(grid)
  rotations = [grid]
  3.times { rotations << rotations.last.transpose.map(&:reverse) }
  rotations + rotations.map { |g| g.map(&:reverse) }
end

def edges(grid)
  [grid.first, grid.map(&:last), grid.last, grid.map(&:first)].map(&:join)
end

# How many tiles have each edge (in either reading direction).
def edge_counts(tiles)
  counts = Hash.new(0)
  tiles.each_value { |g| edges(g).each { |e| counts[[e, e.reverse].min] += 1 } }
  counts
end

def unmatched?(counts, edge)
  counts[[edge, edge.reverse].min] == 1
end

def corners(tiles)
  counts = edge_counts(tiles)
  tiles.select { |_, g| edges(g).count { |e| unmatched?(counts, e) } == 2 }.keys
end

def solve(input)
  corners(parse(input)).reduce(:*)
end

def assemble(tiles)
  counts = edge_counts(tiles)
  size = Math.sqrt(tiles.size).to_i
  start = corners(tiles).first
  first = orientations(tiles[start]).find { |g| unmatched?(counts, g.first.join) && unmatched?(counts, g.map(&:first).join) }
  placed = Array.new(size) { Array.new(size) }
  placed[0][0] = first
  unused = tiles.keys - [start]
  size.times do |r|
    size.times do |c|
      next if r.zero? && c.zero?

      left = c.positive? ? placed[r][c - 1].map(&:last).join : nil
      top = r.positive? ? placed[r - 1][c].last.join : nil
      unused.each do |id|
        grid = orientations(tiles[id]).find do |g|
          (left.nil? || g.map(&:first).join == left) && (top.nil? || g.first.join == top)
        end
        next unless grid

        placed[r][c] = grid
        unused.delete(id)
        break
      end
    end
  end
  placed.flat_map do |row|
    row.map { |g| g[1...-1].map { |line| line[1...-1] } }.transpose.map(&:flatten)
  end
end

def count_monsters(image)
  offsets = MONSTER.each_with_index.flat_map { |line, r| line.chars.each_index.select { |c| line[c] == '#' }.map { |c| [r, c] } }
  (0..(image.size - MONSTER.size)).sum do |r|
    (0..(image[0].size - MONSTER[0].size)).count do |c|
      offsets.all? { |dr, dc| image[r + dr][c + dc] == '#' }
    end
  end
end

def solve2(input)
  image = assemble(parse(input))
  monsters = orientations(image).map { |g| count_monsters(g) }.max
  image.flatten.count('#') - (monsters * MONSTER.join.count('#'))
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    Tile 2311:
    ..##.#..#.
    ##..#.....
    #...##..#.
    ####.#...#
    ##.##.###.
    ##...#.###
    .#.#.#..##
    ..#....#..
    ###...#.#.
    ..###..###

    Tile 1951:
    #.##...##.
    #.####...#
    .....#..##
    #...######
    .##.#....#
    .###.#####
    ###.##.##.
    .###....#.
    ..#.#..#.#
    #...##.#..

    Tile 1171:
    ####...##.
    #..##.#..#
    ##.#..#.#.
    .###.####.
    ..###.####
    .##....##.
    .#...####.
    #.##.####.
    ####..#...
    .....##...

    Tile 1427:
    ###.##.#..
    .#..#.##..
    .#.##.#..#
    #.#.#.##.#
    ....#...##
    ...##..##.
    ...#.#####
    .#.####.#.
    ..#..###.#
    ..##.#..#.

    Tile 1489:
    ##.#.#....
    ..##...#..
    .##..##...
    ..#...#...
    #####...#.
    #..#.#.#.#
    ...#.#.#..
    ##.#...##.
    ..##.##.##
    ###.##.#..

    Tile 2473:
    #....####.
    #..#.##...
    #.##..#...
    ######.#.#
    .#...#.#.#
    .#########
    .###.#..#.
    ########.#
    ##...##.#.
    ..###.#.#.

    Tile 2971:
    ..#.#....#
    #...###...
    #.#.###...
    ##.##..#..
    .#####..##
    .#..####.#
    #..#.#..#.
    ..####.###
    ..#.#.###.
    ...#.#.#.#

    Tile 2729:
    ...#.#.#.#
    ####.#....
    ..#.#.....
    ....#..#.#
    .##..##.#.
    .#.####...
    ####.#.#..
    ##.####...
    ##..#.##..
    #.##...##.

    Tile 3079:
    #.#.#####.
    .#..######
    ..#.......
    ######....
    ####.#..#.
    .#...#.##.
    #.#####.##
    ..#.###...
    ..#.......
    ..#.###...

  INPUT

  def test_solve_example
    assert_equal 20_899_048_083_289, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 107_399_567_124_539, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 273, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 1555, solve2(read_file('input.txt'))
  end
end
