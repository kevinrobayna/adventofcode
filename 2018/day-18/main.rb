# frozen_string_literal: true

require_relative '../../lib/aoc'

def tick(grid)
  h = grid.size
  w = grid[0].size
  Array.new(h) do |y|
    row = +''
    w.times do |x|
      trees = lumber = 0
      ([y - 1, 0].max..[y + 1, h - 1].min).each do |ny|
        ([x - 1, 0].max..[x + 1, w - 1].min).each do |nx|
          next if ny == y && nx == x

          c = grid[ny][nx]
          trees += 1 if c == '|'
          lumber += 1 if c == '#'
        end
      end
      row << case grid[y][x]
             when '.' then trees >= 3 ? '|' : '.'
             when '|' then lumber >= 3 ? '#' : '|'
             else lumber >= 1 && trees >= 1 ? '#' : '.'
             end
    end
    row
  end
end

def resource_value(grid)
  all = grid.join
  all.count('|') * all.count('#')
end

def solve(input, minutes: 10)
  grid = input.lines(chomp: true)
  seen = {}
  minute = 0
  while minute < minutes
    if seen.key?(grid)
      cycle = minute - seen[grid]
      minute += (minutes - minute) / cycle * cycle
      seen.clear
      next if minute >= minutes
    end
    seen[grid] = minute
    grid = tick(grid)
    minute += 1
  end
  resource_value(grid)
end

def solve2(input)
  solve(input, minutes: 1_000_000_000)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    .#.#...|#.
    .....#|##|
    .|..|...#.
    ..|#.....#
    #.#|||#|#|
    ...#.||...
    .|....|...
    ||...#|.#|
    |.||||..|.
    ...#.|..|.
  INPUT

  def test_solve_example
    assert_equal 1147, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 514_944, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 193_050, solve2(read_file('input.txt'))
  end
end
