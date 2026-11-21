# frozen_string_literal: true

require_relative '../../lib/aoc'

def parse(input)
  input.scan(/Disc #(\d+) has (\d+) positions; at time=0, it is at position (\d+)/).map { |d| d.map(&:to_i) }
end

# Sieve: once a disc is aligned, advance in steps of the product of the aligned sizes.
def first_time(discs)
  time = 0
  step = 1
  discs.each do |n, size, pos|
    time += step until ((pos + time + n) % size).zero?
    step = step.lcm(size)
  end
  time
end

def solve(input)
  first_time(parse(input))
end

def solve2(input)
  discs = parse(input)
  first_time(discs + [[discs.size + 1, 11, 0]])
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    Disc #1 has 5 positions; at time=0, it is at position 4.
    Disc #2 has 2 positions; at time=0, it is at position 1.
  INPUT

  def test_solve_example
    assert_equal 5, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 16_824, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 85, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 3_543_984, solve2(read_file('input.txt'))
  end
end
