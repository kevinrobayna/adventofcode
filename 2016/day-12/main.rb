# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end
require_relative '../assembunny'

def solve(input)
  Assembunny.new(input).run['a']
end

def solve2(input)
  Assembunny.new(input, c: 1).run['a']
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    cpy 41 a
    inc a
    inc a
    dec a
    jnz a 2
    dec a
  INPUT

  # Addition loop that the interpreter short-circuits.
  ADDITION = <<~INPUT
    cpy 7 b
    cpy 5 a
    inc a
    dec b
    jnz b -2
  INPUT

  def test_solve_example
    assert_equal 42, solve(EXAMPLE)
    assert_equal 12, solve(ADDITION)
  end

  def test_solve_input
    assert_equal 318_007, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 42, solve2(EXAMPLE)
    assert_equal({ 'a' => 12, 'b' => 0, 'c' => 1, 'd' => 0 }, Assembunny.new(ADDITION, c: 1).run)
  end

  def test_solve2_input
    assert_equal 9_227_661, solve2(read_file('input.txt'))
  end
end
