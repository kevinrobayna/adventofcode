# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

MOD = 20_201_227

def loop_size(public_key)
  value = 1
  size = 0
  until value == public_key
    value = value * 7 % MOD
    size += 1
  end
  size
end

def solve(input)
  card, door = input.split.map(&:to_i)
  door.pow(loop_size(card), MOD)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    5764801
    17807724
  INPUT

  def test_loop_size
    assert_equal 8, loop_size(5_764_801)
    assert_equal 11, loop_size(17_807_724)
  end

  def test_solve_example
    assert_equal 14_897_079, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 7_269_858, solve(read_file('input.txt'))
  end
end
