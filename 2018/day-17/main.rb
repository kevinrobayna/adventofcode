# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

class Reservoir
  def initialize(input)
    clay = input.lines.flat_map do |line|
      a, b, c = line.scan(/\d+/).map(&:to_i)
      line.start_with?('x') ? (b..c).map { |y| [a, y] } : (b..c).map { |x| [x, a] }
    end
    xs, ys = clay.transpose
    @miny, @maxy = ys.minmax
    @minx = xs.min - 1
    width = xs.max - @minx + 2
    @grid = Array.new(@maxy + 2) { Array.new(width, '.') }
    clay.each { |x, y| @grid[y][x - @minx] = '#' }
    fall(500 - @minx, 0)
  end

  def count(*kinds)
    @grid[@miny..@maxy].sum { |row| row.count { |c| kinds.include?(c) } }
  end

  private

  # Water falls from (x, y0) until it hits something, then spreads and rises while contained.
  def fall(x, y0)
    y = y0
    while y < @maxy && @grid[y + 1][x] == '.'
      y += 1
      @grid[y][x] = '|'
    end
    return if y >= @maxy || @grid[y + 1][x] == '|'

    while y >= y0
      left_closed, lx = spread(x, y, -1)
      right_closed, rx = spread(x, y, 1)
      fill = left_closed && right_closed ? '~' : '|'
      (lx..rx).each { |i| @grid[y][i] = fill }
      return if fill == '|'

      y -= 1
    end
  end

  # Spreads sideways; returns [bounded by clay?, furthest x reached].
  def spread(x, y, dir)
    loop do
      return [true, x] if @grid[y][x + dir] == '#'

      x += dir
      @grid[y][x] = '|'
      fall(x, y) if @grid[y + 1][x] == '.'
      return [false, x] unless '#~'.include?(@grid[y + 1][x])
    end
  end
end

def solve(input)
  Reservoir.new(input).count('|', '~')
end

def solve2(input)
  Reservoir.new(input).count('~')
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    x=495, y=2..7
    y=7, x=495..501
    x=501, y=3..7
    x=498, y=2..4
    x=506, y=1..2
    x=498, y=10..13
    x=504, y=10..13
    y=13, x=498..504
  INPUT

  def test_solve_example
    assert_equal 57, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 33_362, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 29, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 27_801, solve2(read_file('input.txt'))
  end
end
