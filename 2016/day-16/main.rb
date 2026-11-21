# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def dragon(a, length)
  a = "#{a}0#{a.reverse.tr('01', '10')}" while a.size < length
  a[0, length]
end

# Each checksum char covers a chunk of 2^k chars; pairwise XNOR-reduction of a chunk is '1' iff it has an even count of 1s.
def checksum(data)
  chunk = 1
  chunk *= 2 while (data.size / chunk).even?
  (0...data.size).step(chunk).map { |i| data[i, chunk].count('1').even? ? '1' : '0' }.join
end

def solve(input, length: 272)
  checksum(dragon(input.strip, length))
end

def solve2(input)
  solve(input, length: 35_651_584)
end

class AoCTest < Minitest::Test
  def test_solve_example
    assert_equal '1111000010100101011110000', dragon('111100001010', 25)
    assert_equal '100', checksum('110010110100')
    assert_equal '01100', solve('10000', length: 20)
  end

  def test_solve_input
    assert_equal '10010110010011110', solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal '01100', checksum(dragon('10000', 20))
  end

  def test_solve2_input
    assert_equal '01101011101100011', solve2(read_file('input.txt'))
  end
end
