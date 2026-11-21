# frozen_string_literal: true

require_relative '../../lib/aoc'

def parse(input)
  input.split("\n\n").map { _1.scan(/\d+/).map(&:to_i) }
end

# Solves a*ax + b*bx = px, a*ay + b*by = py with Cramer's rule; returns tokens or 0.
def tokens(machine, offset: 0, max: nil)
  ax, ay, bx, by, px, py = machine
  px += offset
  py += offset
  det = (ax * by) - (ay * bx)
  return 0 if det.zero?

  a, ra = ((px * by) - (py * bx)).divmod(det)
  b, rb = ((ax * py) - (ay * px)).divmod(det)
  return 0 unless ra.zero? && rb.zero? && a >= 0 && b >= 0

  return 0 if max && (a > max || b > max)

  (3 * a) + b
end

def solve(input)
  parse(input).sum { |m| tokens(m, max: 100) }
end

def solve2(input)
  parse(input).sum { |m| tokens(m, offset: 10_000_000_000_000) }
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    Button A: X+94, Y+34
    Button B: X+22, Y+67
    Prize: X=8400, Y=5400

    Button A: X+26, Y+66
    Button B: X+67, Y+21
    Prize: X=12748, Y=12176

    Button A: X+17, Y+86
    Button B: X+84, Y+37
    Prize: X=7870, Y=6450

    Button A: X+69, Y+23
    Button B: X+27, Y+71
    Prize: X=18641, Y=10279
  INPUT

  def test_solve_example
    assert_equal 480, solve(EXAMPLE)
  end

  def test_solve2_example
    assert_equal 875_318_608_908, solve2(EXAMPLE)
  end
end
