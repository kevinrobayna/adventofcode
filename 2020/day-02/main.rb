# frozen_string_literal: true

require_relative '../../lib/aoc'

def parse(input)
  input.lines.map do |line|
    a, b, char, password = line.match(/(\d+)-(\d+) (\w): (\w+)/).captures
    [a.to_i, b.to_i, char, password]
  end
end

def solve(input)
  parse(input).count { |min, max, char, password| password.count(char).between?(min, max) }
end

def solve2(input)
  parse(input).count { |a, b, char, password| (password[a - 1] == char) ^ (password[b - 1] == char) }
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    1-3 a: abcde
    1-3 b: cdefg
    2-9 c: ccccccccc
  INPUT

  def test_solve_example
    assert_equal 2, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 580, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 1, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 611, solve2(read_file('input.txt'))
  end
end
