# frozen_string_literal: true

require_relative '../../lib/aoc'
require_relative '../assembunny'

def solve(input, eggs: 7)
  Assembunny.new(input, a: eggs).run['a']
end

def solve2(input)
  solve(input, eggs: 12)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    cpy 2 a
    tgl a
    tgl a
    tgl a
    cpy 1 a
    dec a
    dec a
  INPUT

  def test_solve_example
    assert_equal 3, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 10_440, solve(read_file('input.txt'))
  end

  # Multiplication loop (a += b * d) that the interpreter short-circuits.
  MULTIPLY = <<~INPUT
    cpy 6 b
    cpy 7 d
    cpy b c
    inc a
    dec c
    jnz c -2
    dec d
    jnz d -5
  INPUT

  def test_solve2_example
    assert_equal 3, solve2(EXAMPLE)
    assert_equal({ 'a' => 42, 'b' => 6, 'c' => 0, 'd' => 0 }, Assembunny.new(MULTIPLY).run)
    assert_equal 54, solve2(MULTIPLY)
  end

  def test_solve2_input
    assert_equal 479_007_000, solve2(read_file('input.txt'))
  end
end
