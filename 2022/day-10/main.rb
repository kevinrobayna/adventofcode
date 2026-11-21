# frozen_string_literal: true

require_relative '../../lib/aoc'

# AoC 4x6 font, each letter as its 6 rows joined.
FONT = {
  '.##.#..##..######..##..#' => 'A',
  '###.#..####.#..##..####.' => 'B',
  '.##.#..##...#...#..#.##.' => 'C',
  '#####...###.#...#...####' => 'E',
  '#####...###.#...#...#...' => 'F',
  '.##.#..##...#.###..#.###' => 'G',
  '#..##..######..##..##..#' => 'H',
  '..##...#...#...##..#.##.' => 'J',
  '#..##.#.##..#.#.#.#.#..#' => 'K',
  '#...#...#...#...#...####' => 'L',
  '.##.#..##..##..##..#.##.' => 'O',
  '###.#..##..####.#...#...' => 'P',
  '###.#..##..####.#.#.#..#' => 'R',
  '.####...#....##....####.' => 'S',
  '#..##..##..##..##..#.##.' => 'U',
  '####...#..#..#..#...####' => 'Z'
}.freeze

# Value of the X register during each cycle (index 0 is cycle 1).
def register_values(input)
  x = 1
  input.each_line.flat_map do |line|
    op, value = line.split
    during = op == 'addx' ? [x, x] : [x]
    x += value.to_i
    during
  end
end

def solve(input)
  values = register_values(input)
  [20, 60, 100, 140, 180, 220].sum { |cycle| cycle * values[cycle - 1] }
end

def render(input)
  register_values(input).first(240).each_slice(40).map do |row|
    row.each_with_index.map { |x, col| (x - col).abs <= 1 ? '#' : '.' }.join
  end.join("\n")
end

def decode(screen)
  rows = screen.split("\n")
  (0...8).map { |i| FONT.fetch(rows.map { |r| r[i * 5, 4] }.join, '?') }.join
end

def solve2(input)
  decode(render(input))
end

class AoCTest < Minitest::Test
  EXAMPLE_SCREEN = <<~SCREEN.chomp
    ##..##..##..##..##..##..##..##..##..##..
    ###...###...###...###...###...###...###.
    ####....####....####....####....####....
    #####.....#####.....#####.....#####.....
    ######......######......######......####
    #######.......#######.......#######.....
  SCREEN

  def test_solve_example
    assert_equal 13_140, solve(read_file('test.txt'))
  end

  def test_solve_input
    assert_equal 17_180, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal EXAMPLE_SCREEN, render(read_file('test.txt'))
  end

  def test_solve2_input
    assert_equal 'REHPRLUB', solve2(read_file('input.txt'))
  end
end
