# frozen_string_literal: true

require_relative '../../lib/aoc'

def decompressed_length(s, recursive:)
  total = 0
  i = 0
  while i < s.size
    m = s.match(/\((\d+)x(\d+)\)/, i)
    unless m
      total += s.size - i
      break
    end
    total += m.begin(0) - i
    len = m[1].to_i
    times = m[2].to_i
    chunk = s[m.end(0), len]
    total += times * (recursive ? decompressed_length(chunk, recursive:) : chunk.size)
    i = m.end(0) + len
  end
  total
end

def solve(input)
  decompressed_length(input.gsub(/\s/, ''), recursive: false)
end

def solve2(input)
  decompressed_length(input.gsub(/\s/, ''), recursive: true)
end

class AoCTest < Minitest::Test
  def test_solve_example
    { 'ADVENT' => 6, 'A(1x5)BC' => 7, '(3x3)XYZ' => 9, 'A(2x2)BCD(2x2)EFG' => 11, '(6x1)(1x3)A' => 6,
      'X(8x2)(3x3)ABCY' => 18 }.each { |s, n| assert_equal n, solve(s) }
  end

  def test_solve_input
    assert_equal 112_830, solve(read_file('input.txt'))
  end

  def test_solve2_example
    { '(3x3)XYZ' => 9, 'X(8x2)(3x3)ABCY' => 20, '(27x12)(20x12)(13x14)(7x10)(1x12)A' => 241_920,
      '(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN' => 445 }.each { |s, n| assert_equal n, solve2(s) }
  end

  def test_solve2_input
    assert_equal 10_931_789_799, solve2(read_file('input.txt'))
  end
end
