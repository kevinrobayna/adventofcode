# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

RubyVM::YJIT.enable if defined?(RubyVM::YJIT)

def escape_steps(input)
  jumps = input.split.map(&:to_i)
  pc = 0
  steps = 0
  size = jumps.size
  while pc >= 0 && pc < size
    offset = jumps[pc]
    jumps[pc] = yield(offset)
    pc += offset
    steps += 1
  end
  steps
end

def solve(input)
  escape_steps(input) { |o| o + 1 }
end

def solve2(input)
  escape_steps(input) { |o| o >= 3 ? o - 1 : o + 1 }
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    0
    3
    0
    1
    -3
  INPUT

  def test_solve_example
    assert_equal 5, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 325_922, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 10, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 24_490_906, solve2(read_file('input.txt'))
  end
end
