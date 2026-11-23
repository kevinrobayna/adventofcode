# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

MIRRORS = {
  '/' => { [0, 1] => [[-1, 0]], [0, -1] => [[1, 0]], [1, 0] => [[0, -1]], [-1, 0] => [[0, 1]] },
  '\\' => { [0, 1] => [[1, 0]], [0, -1] => [[-1, 0]], [1, 0] => [[0, 1]], [-1, 0] => [[0, -1]] }
}.freeze

def next_dirs(char, dir)
  case char
  when '/', '\\' then MIRRORS[char][dir]
  when '|' then dir[1].zero? ? [dir] : [[-1, 0], [1, 0]]
  when '-' then dir[0].zero? ? [dir] : [[0, -1], [0, 1]]
  else [dir]
  end
end

def energized(grid, start, dir)
  rows = grid.length
  cols = grid.first.length
  seen = {}
  stack = [[start, dir]]
  until stack.empty?
    (r, c), d = stack.pop
    next if r.negative? || c.negative? || r >= rows || c >= cols

    key = [r, c, d]
    next if seen[key]

    seen[key] = true
    next_dirs(grid[r][c], d).each { |nd| stack << [[r + nd[0], c + nd[1]], nd] }
  end
  seen.keys.map { it[0, 2] }.uniq.size
end

def solve(input)
  energized(input.lines.map(&:strip), [0, 0], [0, 1])
end

def solve2(input)
  grid = input.lines.map(&:strip)
  rows = grid.length
  cols = grid.first.length
  starts = (0...rows).flat_map { |r| [[[r, 0], [0, 1]], [[r, cols - 1], [0, -1]]] } +
           (0...cols).flat_map { |c| [[[0, c], [1, 0]], [[rows - 1, c], [-1, 0]]] }
  starts.map { |pos, dir| energized(grid, pos, dir) }.max
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~'INPUT'
    .|...\....
    |.-.\.....
    .....|-...
    ........|.
    ..........
    .........\
    ..../.\\..
    .-.-/..|..
    .|....-|.\
    ..//.|....
  INPUT

  def test_solve_example
    assert_equal 46, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 8551, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 51, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 8754, solve2(read_file('input.txt'))
  end
end
