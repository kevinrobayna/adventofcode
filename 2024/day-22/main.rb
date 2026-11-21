# frozen_string_literal: true

require_relative '../../lib/aoc'

PRUNE = (1 << 24) - 1

def next_secret(secret)
  secret = ((secret << 6) ^ secret) & PRUNE
  secret = ((secret >> 5) ^ secret) & PRUNE
  ((secret << 11) ^ secret) & PRUNE
end

def solve(input)
  input.split.sum do |line|
    secret = line.to_i
    2000.times { secret = next_secret(secret) }
    secret
  end
end

# Sequences of 4 price changes are packed into a base-19 number; every buyer sells at the
# first occurrence of a sequence, so remember which buyer last saw each sequence.
def solve2(input)
  totals = Array.new(19**4, 0)
  last_seen = Array.new(19**4)
  input.split.each_with_index do |line, buyer|
    secret = line.to_i
    price = secret % 10
    key = 0
    2000.times do |i|
      secret = next_secret(secret)
      new_price = secret % 10
      key = ((key * 19) + (new_price - price + 9)) % (19**4)
      price = new_price
      next if i < 3 || last_seen[key] == buyer

      last_seen[key] = buyer
      totals[key] += price
    end
  end
  totals.max
end

class AoCTest < Minitest::Test
  def test_next_secret
    secrets = [123]
    10.times { secrets << next_secret(secrets.last) }
    assert_equal [15_887_950, 16_495_136, 527_345, 704_524, 1_553_684, 12_683_156, 11_100_544, 12_249_484,
                  7_753_432, 5_908_254], secrets.drop(1)
  end

  def test_solve_example
    assert_equal 37_327_623, solve("1\n10\n100\n2024\n")
  end

  def test_solve2_example
    assert_equal 23, solve2("1\n2\n3\n2024\n")
  end

  def test_solve_input
    assert_equal 13_461_553_007, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 1499, solve2(read_file('input.txt'))
  end
end
