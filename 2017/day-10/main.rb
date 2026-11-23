# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end
require_relative '../knot_hash'

def solve(input, size: 256)
  list = KnotHash.sparse(input.split(',').map(&:to_i), size: size)
  list[0] * list[1]
end

def solve2(input)
  KnotHash.hex(input.strip)
end

class AoCTest < Minitest::Test
  def test_solve_example
    assert_equal 12, solve('3,4,1,5', size: 5)
  end

  def test_solve_input
    assert_equal 62_238, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 'a2582a3a0e66e6e86e3812dcb672a272', solve2('')
    assert_equal '33efeb34ea91902bb2f59c9920caa6cd', solve2('AoC 2017')
    assert_equal '3efbe78a8d82f29979031a4aa0b16a9d', solve2('1,2,3')
    assert_equal '63960835bcdc130f0b66d7ff4f6a5a8e', solve2('1,2,4')
  end

  def test_solve2_input
    assert_equal '2b0c9cc0449507a0db3babd57ad9e8d8', solve2(read_file('input.txt'))
  end
end
