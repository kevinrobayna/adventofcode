# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

FIRST_CODE = 20_151_125
MULTIPLIER = 252_533
MODULUS = 33_554_393

# Codes are filled along diagonals; the n-th code is FIRST_CODE * MULTIPLIER^(n-1) mod MODULUS.
def code_at(row, column)
  diagonal = row + column - 1
  index = ((diagonal * (diagonal - 1)) / 2) + column
  (FIRST_CODE * MULTIPLIER.pow(index - 1, MODULUS)) % MODULUS
end

def solve(input)
  row, column = input.scan(/\d+/).map(&:to_i)
  code_at(row, column)
end

class AoCTest < Minitest::Test
  def test_solve_example
    assert_equal 20_151_125, code_at(1, 1)
    assert_equal 31_916_031, code_at(2, 1)
    assert_equal 18_749_137, code_at(1, 2)
    assert_equal 21_629_792, code_at(2, 2)
    assert_equal 27_995_004, code_at(6, 6)
    assert_equal 1_534_922, code_at(6, 5)
    assert_equal 33_511_524, solve('row 1, column 6.')
  end

  def test_solve_input
    assert_equal 8_997_277, solve(read_file('input.txt'))
  end
end
