# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

# Sieve over house numbers; target / 10 is a safe upper bound since house n gets >= 10n presents.
# Sieves houses 1..limit, doubling the limit until one reaches the target. House counts
# up to the limit are exact, and house target/per_elf always qualifies, so it terminates.
# The starting limit only affects speed, never the result.
def first_house(target, per_elf:, max_visits: nil, limit: target / per_elf / 40)
  cap = target / per_elf
  limit = limit.clamp(1, cap)
  loop do
    found = sieve(target, limit, per_elf, max_visits)
    return found if found

    limit = [limit * 2, cap].min
  end
end

def sieve(target, limit, per_elf, max_visits)
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

  def test_first_house_grows_limit_until_found
    assert_equal 8, first_house(150, per_elf: 10, limit: 1)
    assert_equal 4, first_house(77, per_elf: 11, max_visits: 50, limit: 2)
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
