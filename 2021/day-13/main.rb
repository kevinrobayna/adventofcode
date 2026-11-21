# frozen_string_literal: true

require_relative '../../lib/aoc'

# 4x6 glyphs used by AoC for rendered letters.
LETTERS = {
  '.##.#..##..######..##..#' => 'A', '###.#..####.#..##..####.' => 'B', '.##.#..##...#...#..#.##.' => 'C',
  '#####...###.#...#...####' => 'E', '#####...###.#...#...#...' => 'F', '.##.#..##...#.###..#.###' => 'G',
  '#..##..######..##..##..#' => 'H', '..##...#...#...##..#.##.' => 'J', '#..##.#.##..#.#.#.#.#..#' => 'K',
  '#...#...#...#...#...####' => 'L', '###.#..##..####.#...#...' => 'P', '###.#..##..####.#.#.#..#' => 'R',
  '#..##..##..##..##..#.##.' => 'U', '####...#..#..#..#...####' => 'Z'
}.freeze

def parse(input)
  dots_part, folds_part = input.split("\n\n")
  dots = dots_part.split("\n").to_set { |line| line.split(',').map(&:to_i) }
  folds = folds_part.scan(/([xy])=(\d+)/).map { |axis, v| [axis, v.to_i] }
  [dots, folds]
end

def fold(dots, (axis, line))
  dots.to_set do |x, y|
    if axis == 'x' && x > line then [(2 * line) - x, y]
    elsif axis == 'y' && y > line then [x, (2 * line) - y]
    else [x, y]
    end
  end
end

def solve(input)
  dots, folds = parse(input)
  fold(dots, folds.first).size
end

def render(dots)
  width = dots.map(&:first).max + 1
  height = dots.map(&:last).max + 1
  Array.new(height) { |y| Array.new(width) { |x| dots.include?([x, y]) ? '#' : '.' }.join }.join("\n")
end

def decode(rendered)
  rows = rendered.split("\n").map { |row| row.ljust(40, '.') }
  (0...(rows[0].size / 5)).map { |i| LETTERS.fetch(rows.map { |row| row[i * 5, 4] }.join, '?') }.join
end

def solve2(input)
  dots, folds = parse(input)
  render(folds.reduce(dots) { |d, f| fold(d, f) })
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    6,10
    0,14
    9,10
    0,3
    10,4
    4,11
    6,0
    6,12
    4,1
    0,13
    10,12
    3,4
    3,0
    8,4
    1,10
    2,14
    8,10
    9,0

    fold along y=7
    fold along x=5
  INPUT

  def test_solve_example
    assert_equal 17, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 618, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal "#####\n#...#\n#...#\n#...#\n#####", solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 'ALREKFKU', decode(solve2(read_file('input.txt')))
  end
end
