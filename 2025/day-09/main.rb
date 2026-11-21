# frozen_string_literal: true

require_relative '../../lib/aoc'

def red_tiles(input)
  input.split.map { |line| line.split(',').map(&:to_i) }
end

def area(a, b)
  ((a[0] - b[0]).abs + 1) * ((a[1] - b[1]).abs + 1)
end

def solve(input)
  red_tiles(input).combination(2).map { |a, b| area(a, b) }.max
end

# Compressed axis: every coordinate c and c + 1 is a breakpoint, so each red/green column gets its own cell.
def compress(values)
  (values.flat_map { |v| [v, v + 1] } + [values.min - 1, values.max + 2]).uniq.sort.each_with_index.to_h
end

# Marks cells outside the loop (flood fill from the padded border), returns 2D prefix sums of them.
def outside_prefix(tiles, xs, ys)
  w = xs.size
  h = ys.size
  wall = Array.new(h) { Array.new(w, false) }
  tiles.zip(tiles.rotate).each do |(ax, ay), (bx, by)|
    x1, x2 = [xs[ax], xs[bx]].minmax
    y1, y2 = [ys[ay], ys[by]].minmax
    (y1..y2).each { |y| (x1..x2).each { |x| wall[y][x] = true } }
  end
  outside = Array.new(h) { Array.new(w, false) }
  outside[0][0] = true
  stack = [[0, 0]]
  until stack.empty?
    x, y = stack.pop
    [[x + 1, y], [x - 1, y], [x, y + 1], [x, y - 1]].each do |nx, ny|
      next if nx.negative? || ny.negative? || nx >= w || ny >= h || wall[ny][nx] || outside[ny][nx]

      outside[ny][nx] = true
      stack << [nx, ny]
    end
  end
  prefix = Array.new(h + 1) { Array.new(w + 1, 0) }
  h.times do |y|
    w.times do |x|
      prefix[y + 1][x + 1] = prefix[y][x + 1] + prefix[y + 1][x] - prefix[y][x] + (outside[y][x] ? 1 : 0)
    end
  end
  prefix
end

def solve2(input)
  tiles = red_tiles(input)
  xs = compress(tiles.map(&:first))
  ys = compress(tiles.map(&:last))
  prefix = outside_prefix(tiles, xs, ys)
  tiles.combination(2).filter_map do |a, b|
    x1, x2 = [xs[a[0]], xs[b[0]]].minmax
    y1, y2 = [ys[a[1]], ys[b[1]]].minmax
    outside = prefix[y2 + 1][x2 + 1] - prefix[y1][x2 + 1] - prefix[y2 + 1][x1] + prefix[y1][x1]
    area(a, b) if outside.zero?
  end.max
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    7,1
    11,1
    11,7
    9,7
    9,5
    2,5
    2,3
    7,3
  INPUT

  def test_solve_example
    assert_equal 50, solve(EXAMPLE)
  end

  def test_solve2_example
    assert_equal 24, solve2(EXAMPLE)
  end

  # A U shape: the widest rectangle would span the notch, which is outside the loop.
  def test_solve2_concave
    u_shape = "0,0\n10,0\n10,10\n6,10\n6,2\n4,2\n4,10\n0,10\n"
    assert_equal 55, solve2(u_shape)
  end

  def test_solve_input
    assert_equal 4_777_967_538, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 1_439_894_345, solve2(read_file('input.txt'))
  end
end
