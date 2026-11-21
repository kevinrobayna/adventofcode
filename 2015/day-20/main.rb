# frozen_string_literal: true

require_relative '../../lib/aoc'

# Sieve over house numbers; target / 10 is a safe upper bound since house n gets >= 10n presents.
def first_house(target, per_elf:, max_visits: nil)
  limit = target / per_elf
  presents = Array.new(limit + 1, 0)
  (1..limit).each do |elf|
    last = max_visits ? [limit, elf * max_visits].min : limit
    elf.step(last, elf) { |house| presents[house] += elf * per_elf }
  end
  presents.index { |p| p >= target }
end

def solve(input)
  first_house(input.to_i, per_elf: 10)
end

def solve2(input)
  first_house(input.to_i, per_elf: 11, max_visits: 50)
end

class AoCTest < Minitest::Test
  def test_solve_example
    assert_equal 1, solve('10')
    assert_equal 4, solve('70')
    assert_equal 6, solve('120')
    assert_equal 8, solve('150')
  end

  def test_solve_input
    assert_equal 831_600, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 4, solve2('77')
  end

  def test_solve2_input
    assert_equal 884_520, solve2(read_file('input.txt'))
  end
end
