# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def parse(input)
  rows = input.lines.map(&:chomp)
  antennas = Hash.new { |h, k| h[k] = [] }
  rows.each_with_index do |row, r|
    row.each_char.with_index { |ch, c| antennas[ch] << [r, c] unless ch == '.' }
  end
  [antennas.values, rows.size, rows[0].size]
end

# Counts in-bounds cells reached by stepping from each antenna away from its partner.
# `steps` is the range of multiples of the pair distance to visit.
def antinodes(input, steps)
  groups, rows, cols = parse(input)
  inside = ->(r, c) { r.between?(0, rows - 1) && c.between?(0, cols - 1) }
  found = Set.new
  groups.each do |group|
    group.permutation(2) do |(r1, c1), (r2, c2)|
      dr = r2 - r1
      dc = c2 - c1
      steps.each do |k|
        r = r2 + (dr * k)
        c = c2 + (dc * k)
        break unless inside.call(r, c)

        found << [r, c]
      end
    end
  end
  found.size
end

def solve(input)
  antinodes(input, 1..1)
end

def solve2(input)
  antinodes(input, 0..)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    ............
    ........0...
    .....0......
    .......0....
    ....0.......
    ......A.....
    ............
    ............
    ........A...
    .........A..
    ............
    ............
  INPUT

  EXAMPLE_T = <<~INPUT
    T.........
    ...T......
    .T........
    ..........
    ..........
    ..........
    ..........
    ..........
    ..........
    ..........
  INPUT

  def test_solve_example
    assert_equal 14, solve(EXAMPLE)
  end

  def test_solve2_example
    assert_equal 34, solve2(EXAMPLE)
    assert_equal 9, solve2(EXAMPLE_T)
  end

  def test_solve_input
    assert_equal 327, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 1233, solve2(read_file('input.txt'))
  end
end
