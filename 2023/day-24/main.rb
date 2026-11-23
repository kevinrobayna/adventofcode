# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def parse(input)
  input.lines.map { it.scan(/-?\d+/).map(&:to_i).each_slice(3).to_a }
end

# Counts pairs whose XY paths cross (in the future for both) inside the test area.
def solve(input, min: 200_000_000_000_000, max: 400_000_000_000_000)
  parse(input).combination(2).count do |((px1, py1, _), (vx1, vy1, _)), ((px2, py2, _), (vx2, vy2, _))|
    det = (vx1 * vy2) - (vy1 * vx2)
    next false if det.zero? # parallel

    dx = px2 - px1
    dy = py2 - py1
    t1 = Rational((dx * vy2) - (dy * vx2), det)
    t2 = Rational((dx * vy1) - (dy * vx1), det)
    next false if t1.negative? || t2.negative?

    x = px1 + (vx1 * t1)
    y = py1 + (vy1 * t1)
    x.between?(min, max) && y.between?(min, max)
  end
end

def sub(a, b) = a.zip(b).map { |x, y| x - y }

def cross(a, b)
  [(a[1] * b[2]) - (a[2] * b[1]), (a[2] * b[0]) - (a[0] * b[2]), (a[0] * b[1]) - (a[1] * b[0])]
end

# Gaussian elimination over Rationals.
def solve_linear(matrix, rhs)
  n = rhs.size
  m = matrix.each_with_index.map { |row, i| row.map { Rational(it) } + [Rational(rhs[i])] }
  n.times do |col|
    pivot = (col...n).find { |r| !m[r][col].zero? }
    m[col], m[pivot] = m[pivot], m[col]
    (0...n).each do |r|
      next if r == col

      factor = m[r][col] / m[col][col]
      m[r] = m[r].zip(m[col]).map { |a, b| a - (factor * b) }
    end
  end
  (0...n).map { m[it][n] / m[it][it] }
end

# For the rock (P, V) and every hailstone (p, v): (P - p) x (V - v) = 0. Subtracting the equation of
# hailstone i from j cancels the non-linear P x V term:
#   P x (vj - vi) + (pj - pi) x V = pj x vj - pi x vi
def solve2(input)
  hail = parse(input)
  p0, v0 = hail[0]
  rows = []
  rhs = []
  hail[1, 2].each do |pj, vj|
    d = sub(vj, v0)
    e = sub(pj, p0)
    rows << [0, d[2], -d[1], 0, -e[2], e[1]]
    rows << [-d[2], 0, d[0], e[2], 0, -e[0]]
    rows << [d[1], -d[0], 0, -e[1], e[0], 0]
    rhs.concat(sub(cross(pj, vj), cross(p0, v0)))
  end
  solve_linear(rows, rhs).first(3).sum.to_i
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    19, 13, 30 @ -2,  1, -2
    18, 19, 22 @ -1, -1, -2
    20, 25, 34 @ -2, -2, -4
    12, 31, 28 @ -1, -2, -1
    20, 19, 15 @  1, -5, -3
  INPUT

  def test_solve_example
    assert_equal 2, solve(EXAMPLE, min: 7, max: 27)
  end

  def test_solve_input
    assert_equal 12_343, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 47, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 769_281_292_688_187, solve2(read_file('input.txt'))
  end
end
