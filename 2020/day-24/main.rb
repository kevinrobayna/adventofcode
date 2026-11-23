# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

# Axial hex coordinates.
HEX = { 'e' => [1, 0], 'w' => [-1, 0], 'ne' => [1, -1], 'nw' => [0, -1], 'se' => [0, 1], 'sw' => [-1, 1] }.freeze

def black_tiles(input)
  input.split.each_with_object(Set.new) do |line, black|
    tile = line.scan(/e|w|ne|nw|se|sw/).reduce([0, 0]) { |(q, r), d| [q + HEX[d][0], r + HEX[d][1]] }
    black.add?(tile) || black.delete(tile)
  end
end

def solve(input)
  black_tiles(input).size
end

def solve2(input, days: 100)
  black = black_tiles(input)
  days.times do
    counts = Hash.new(0)
    black.each { |q, r| HEX.each_value { |dq, dr| counts[[q + dq, r + dr]] += 1 } }
    black = counts.each_with_object(Set.new) do |(tile, n), nxt|
      nxt << tile if n == 2 || (n == 1 && black.include?(tile))
    end
  end
  black.size
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    sesenwnenenewseeswwswswwnenewsewsw
    neeenesenwnwwswnenewnwwsewnenwseswesw
    seswneswswsenwwnwse
    nwnwneseeswswnenewneswwnewseswneseene
    swweswneswnenwsewnwneneseenw
    eesenwseswswnenwswnwnwsewwnwsene
    sewnenenenesenwsewnenwwwse
    wenwwweseeeweswwwnwwe
    wsweesenenewnwwnwsenewsenwwsesesenwne
    neeswseenwwswnwswswnw
    nenwswwsewswnenenewsenwsenwnesesenew
    enewnwewneswsewnwswenweswnenwsenwsw
    sweneswneswneneenwnewenewwneswswnese
    swwesenesewenwneswnwwneseswwne
    enesenwswwswneneswsenwnewswseenwsese
    wnwnesenesenenwwnenwsewesewsesesew
    nenewswnwewswnenesenwnesewesw
    eneswnwswnwsenenwnwnwwseeswneewsenese
    neswnwewnwnwseenwseesewsenwsweewe
    wseweeenwnesenwwwswnew
  INPUT

  def test_solve_example
    assert_equal 10, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 479, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 15, solve2(EXAMPLE, days: 1)
    assert_equal 37, solve2(EXAMPLE, days: 10)
    assert_equal 2208, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 4135, solve2(read_file('input.txt'))
  end
end
