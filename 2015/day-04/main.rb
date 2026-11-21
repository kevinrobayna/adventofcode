# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

require 'digest'

# Finds the lowest n >= start whose MD5("#{key}#{n}") hex digest starts with `prefix`.
def mine(key, prefix, start: 1)
  key = key.strip
  md5 = Digest::MD5.new
  (start..).find { |n| md5.reset.update(key).update(n.to_s).hexdigest.start_with?(prefix) }
end

def solve(input)
  mine(input, '00000')
end

# Every 6-zero hash is also a 5-zero hash, so the search can resume from part 1.
def solve2(input)
  mine(input, '000000', start: solve(input))
end

class AoCTest < Minitest::Test
  def test_solve_example
    assert_equal 609_043, solve('abcdef')
  end

  def test_solve_input
    assert_equal 282_749, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 9_962_624, solve2(read_file('input.txt'))
  end
end
