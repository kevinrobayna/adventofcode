# frozen_string_literal: true

require_relative '../../lib/aoc'
require_relative '../knot_hash'

def disk_grid(key)
  (0...128).map do |row|
    KnotHash.bytes("#{key.strip}-#{row}").map { |b| format('%08b', b) }.join
  end
end

def solve(input)
  disk_grid(input).sum { |row| row.count('1') }
end

def solve2(input)
  used = Set.new
  disk_grid(input).each_with_index do |row, y|
    row.each_char.with_index { |c, x| used << [x, y] if c == '1' }
  end
  regions = 0
  until used.empty?
    regions += 1
    stack = [used.first]
    used.delete(stack.first)
    until stack.empty?
      x, y = stack.pop
      [[x + 1, y], [x - 1, y], [x, y + 1], [x, y - 1]].each { |n| stack << n if used.delete?(n) }
    end
  end
  regions
end

class AoCTest < Minitest::Test
  EXAMPLE = 'flqrgnkx'

  def test_solve_example
    assert_equal 8108, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 8_148, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 1242, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 1_180, solve2(read_file('input.txt'))
  end
end
