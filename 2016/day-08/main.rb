# frozen_string_literal: true

require_relative '../../lib/aoc'

LETTERS = {
  '.##.#..##..######..##..#' => 'A', '###.#..####.#..##..####.' => 'B', '.##.#..##...#...#..#.##.' => 'C',
  '#####...###.#...#...####' => 'E', '#####...###.#...#...#...' => 'F', '.##.#..##...#.###..#.###' => 'G',
  '#..##..######..##..##..#' => 'H', '.###..#...#...#...#..###' => 'I', '..##...#...#...##..#.##.' => 'J',
  '#..##.#.##..#.#.#.#.#..#' => 'K', '#...#...#...#...#...####' => 'L', '.##.#..##..##..##..#.##.' => 'O',
  '###.#..##..####.#...#...' => 'P', '###.#..##..####.#.#.#..#' => 'R', '.####...#....##....####.' => 'S',
  '#..##..##..##..##..#.##.' => 'U', '#...#....#.#..#...#...#.' => 'Y', '####...#..#..#..#...####' => 'Z'
}.freeze

def screen(input, width:, height:)
  grid = Array.new(height) { Array.new(width, false) }
  input.each_line do |line|
    case line
    when /rect (\d+)x(\d+)/
      ::Regexp.last_match(2).to_i.times { |y| ::Regexp.last_match(1).to_i.times { |x| grid[y][x] = true } }
    when /rotate row y=(\d+) by (\d+)/
      grid[::Regexp.last_match(1).to_i].rotate!(-::Regexp.last_match(2).to_i)
    when /rotate column x=(\d+) by (\d+)/
      x = ::Regexp.last_match(1).to_i
      col = grid.map { |row| row[x] }.rotate(-::Regexp.last_match(2).to_i)
      grid.each_with_index { |row, y| row[x] = col[y] }
    end
  end
  grid
end

def solve(input, width: 50, height: 6)
  screen(input, width:, height:).flatten.count(true)
end

def solve2(input, width: 50, height: 6)
  grid = screen(input, width:, height:)
  (0...width).step(5).map do |x|
    key = grid.map { |row| row[x, 4].map { |on| on ? '#' : '.' }.join }.join
    LETTERS.fetch(key, '?')
  end.join
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    rect 3x2
    rotate column x=1 by 1
    rotate row y=0 by 4
    rotate column x=1 by 1
  INPUT

  def test_solve_example
    assert_equal 6, solve(EXAMPLE, width: 7, height: 3)
  end

  def test_solve_input
    assert_equal 106, solve(read_file('input.txt'))
  end

  def test_solve2_example
    expected = [[false, true, false, false, true, false, true],
                [true, false, true, false, false, false, false],
                [false, true, false, false, false, false, false]]

    assert_equal expected, screen(EXAMPLE, width: 7, height: 3)
  end

  def test_solve2_input
    assert_equal 'CFLELOYFCS', solve2(read_file('input.txt'))
  end
end
