# frozen_string_literal: true

require_relative '../../lib/aoc'

# Enhances the image `times` times; tracks the infinite background since algorithm[0] may be lit.
def enhance(input, times)
  algorithm, image = input.split("\n\n")
  algorithm = algorithm.delete("\n").chars.map { |ch| ch == '#' }
  grid = image.split("\n").map { |row| row.chars.map { |ch| ch == '#' } }
  background = false
  times.times do
    rows = grid.size
    cols = grid[0].size
    grid = Array.new(rows + 2) do |r|
      Array.new(cols + 2) do |c|
        index = 0
        (r - 2..r).each do |sr|
          (c - 2..c).each do |sc|
            lit = sr.between?(0, rows - 1) && sc.between?(0, cols - 1) ? grid[sr][sc] : background
            index = (index << 1) | (lit ? 1 : 0)
          end
        end
        algorithm[index]
      end
    end
    background = background ? algorithm[511] : algorithm[0]
  end
  grid.sum { |row| row.count(true) }
end

def solve(input)
  enhance(input, 2)
end

def solve2(input)
  enhance(input, 50)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    ..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

    #..#.
    #....
    ##..#
    ..#..
    ..###
  INPUT

  def test_solve_example
    assert_equal 35, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 5597, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 3351, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 18_723, solve2(read_file('input.txt'))
  end
end
