# frozen_string_literal: true

require_relative '../../lib/aoc'

def stars(input)
  input.lines.map { |l| l.scan(/-?\d+/).map(&:to_i) }
end

# Steps until the bounding box height is minimal; returns [seconds, positions].
def converge(input)
  pts = stars(input)
  size = lambda do |t|
    pts.map { |x, y, vx, vy| [x + (vx * t), y + (vy * t)] }.transpose.sum { |c| c.minmax.then { |a, b| b - a } }
  end
  t = 0
  t += 1 while size.call(t + 1) < size.call(t)
  [t, pts.map { |x, y, vx, vy| [x + (vx * t), y + (vy * t)] }]
end

def render(points)
  set = points.to_set
  (xmin, xmax), (ymin, ymax) = points.transpose.map(&:minmax)
  (ymin..ymax).map { |y| (xmin..xmax).map { |x| set.include?([x, y]) ? '#' : '.' }.join }.join("\n")
end

def solve(input)
  render(converge(input).last)
end

def solve2(input)
  converge(input).first
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    position=< 9,  1> velocity=< 0,  2>
    position=< 7,  0> velocity=<-1,  0>
    position=< 3, -2> velocity=<-1,  1>
    position=< 6, 10> velocity=<-2, -1>
    position=< 2, -4> velocity=< 2,  2>
    position=<-6, 10> velocity=< 2, -2>
    position=< 1,  8> velocity=< 1, -1>
    position=< 1,  7> velocity=< 1,  0>
    position=<-3, 11> velocity=< 1, -2>
    position=< 7,  6> velocity=<-1, -1>
    position=<-2,  3> velocity=< 1,  0>
    position=<-4,  3> velocity=< 2,  0>
    position=<10, -3> velocity=<-1,  1>
    position=< 5, 11> velocity=< 1, -2>
    position=< 4,  7> velocity=< 0, -1>
    position=< 8, -2> velocity=< 0,  1>
    position=<15,  0> velocity=<-2,  0>
    position=< 1,  6> velocity=< 1,  0>
    position=< 8,  9> velocity=< 0, -1>
    position=< 3,  3> velocity=<-1,  1>
    position=< 0,  5> velocity=< 0, -1>
    position=<-2,  2> velocity=< 2,  0>
    position=< 5, -2> velocity=< 1,  2>
    position=< 1,  4> velocity=< 2,  1>
    position=<-2,  7> velocity=< 2, -2>
    position=< 3,  6> velocity=<-1, -1>
    position=< 5,  0> velocity=< 1,  0>
    position=<-6,  0> velocity=< 2,  0>
    position=< 5,  9> velocity=< 1, -2>
    position=<14,  7> velocity=<-2,  0>
    position=<-3,  6> velocity=< 2, -1>
  INPUT

  HI = <<~OUT.chomp
    #...#..###
    #...#...#.
    #...#...#.
    #####...#.
    #...#...#.
    #...#...#.
    #...#...#.
    #...#..###
  OUT

  # GEJKHGHZ
  MESSAGE = <<~OUT.chomp
    .####...######.....###..#....#..#....#...####...#....#..######
    #....#..#...........#...#...#...#....#..#....#..#....#.......#
    #.......#...........#...#..#....#....#..#.......#....#.......#
    #.......#...........#...#.#.....#....#..#.......#....#......#.
    #.......#####.......#...##......######..#.......######.....#..
    #..###..#...........#...##......#....#..#..###..#....#....#...
    #....#..#...........#...#.#.....#....#..#....#..#....#...#....
    #....#..#.......#...#...#..#....#....#..#....#..#....#..#.....
    #...##..#.......#...#...#...#...#....#..#...##..#....#..#.....
    .###.#..######...###....#....#..#....#...###.#..#....#..######
  OUT

  def test_solve_example
    assert_equal HI, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal MESSAGE, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 3, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 10_681, solve2(read_file('input.txt'))
  end
end
