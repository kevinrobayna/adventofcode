# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def find_most_common_digits(values, index)
  zeros = values.count { |element| element[index] == '0' }
  [zeros, values.count - zeros]
end

def solve(input)
  content = input.split("\n")
  gamma = +''
  epsilon = +''
  (0...content.first.length).each do |index|
    zeros, ones = find_most_common_digits(content, index)
    gamma << (zeros > ones ? '0' : '1')
    epsilon << (zeros > ones ? '1' : '0')
  end
  gamma.to_i(2) * epsilon.to_i(2)
end

# Filters by bit criteria until one number remains. The block picks the bit to keep from (zeros, ones).
def rating(values)
  (0...values.first.length).each do |index|
    break if values.size <= 1

    bit = yield(*find_most_common_digits(values, index))
    values = values.select { |num| num[index] == bit }
  end
  values.first.to_i(2)
end

def solve2(input)
  values = input.split("\n")
  oxygen = rating(values) { |zeros, ones| ones >= zeros ? '1' : '0' }
  co2 = rating(values) { |zeros, ones| ones < zeros ? '1' : '0' }
  oxygen * co2
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    00100
    11110
    10110
    10111
    10101
    01111
    00111
    11100
    10000
    11001
    00010
    01010
  INPUT

  def test_solve_example
    assert_equal 198, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 3_148_794, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 230, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 2_795_310, solve2(read_file('input.txt'))
  end
end
