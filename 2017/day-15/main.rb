# frozen_string_literal: true

require_relative '../../lib/aoc'

RubyVM::YJIT.enable if defined?(RubyVM::YJIT)

MOD = 2_147_483_647
FACTOR_A = 16_807
FACTOR_B = 48_271

def generator_starts(input)
  input.scan(/\d+/).map(&:to_i)
end

def solve(input, pairs: 40_000_000)
  a, b = generator_starts(input)
  matches = 0
  pairs.times do
    a = a * FACTOR_A % MOD
    b = b * FACTOR_B % MOD
    matches += 1 if (a & 0xffff) == (b & 0xffff)
  end
  matches
end

def solve2(input, pairs: 5_000_000)
  a, b = generator_starts(input)
  matches = 0
  pairs.times do
    a = a * FACTOR_A % MOD
    a = a * FACTOR_A % MOD while a & 3 != 0
    b = b * FACTOR_B % MOD
    b = b * FACTOR_B % MOD while b & 7 != 0
    matches += 1 if (a & 0xffff) == (b & 0xffff)
  end
  matches
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    Generator A starts with 65
    Generator B starts with 8921
  INPUT

  def test_solve_example
    assert_equal 1, solve(EXAMPLE, pairs: 5)
    assert_equal 588, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 619, solve(read_file('input.txt'))
  end

  def test_solve2_example
    # The first match in picky mode is the 1056th pair.
    assert_equal 0, solve2(EXAMPLE, pairs: 1055)
    assert_equal 1, solve2(EXAMPLE, pairs: 1056)
    assert_equal 309, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 290, solve2(read_file('input.txt'))
  end
end
