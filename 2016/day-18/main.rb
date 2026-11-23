# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

# Rows are bitmasks (1 = trap); a tile is a trap iff exactly one of its left/right neighbours is.
def safe_tiles(first_row, rows)
  row = first_row.strip
  width = row.size
  mask = (1 << width) - 1
  bits = row.tr('.^', '01').to_i(2)
  (0...rows).sum do
    safe = width - bits.to_s(2).count('1')
    bits = ((bits << 1) ^ (bits >> 1)) & mask
    safe
  end
end

def solve(input, rows: 40)
  safe_tiles(input, rows)
end

def solve2(input)
  safe_tiles(input, 400_000)
end

class AoCTest < Minitest::Test
  def test_solve_example
    assert_equal 6, solve('..^^.', rows: 3)
    assert_equal 38, solve('.^^.^.^^^^', rows: 10)
  end

  def test_solve_input
    assert_equal 2013, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 38, safe_tiles('.^^.^.^^^^', 10)
  end

  def test_solve2_input
    assert_equal 20_006_289, solve2(read_file('input.txt'))
  end
end
