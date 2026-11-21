# frozen_string_literal: true

require_relative '../../lib/aoc'

def nice?(word)
  word.count('aeiou') >= 3 && word.match?(/(.)\1/) && !word.match?(/ab|cd|pq|xy/)
end

def nice2?(word)
  word.match?(/(..).*\1/) && word.match?(/(.).\1/)
end

def solve(input)
  input.lines.count { |line| nice?(line.strip) }
end

def solve2(input)
  input.lines.count { |line| nice2?(line.strip) }
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    ugknbfddgicrmopn
    aaa
    jchzalrnumimnmhp
    haegwjzuvuyypxyu
    dvszwmarrgswjxmb
  INPUT

  EXAMPLE2 = <<~INPUT
    qjhvhtzxzqqjkmpb
    xxyxx
    uurcxstgmygtbstg
    ieodomkazucvgmuy
    aaa
  INPUT

  def test_solve_example
    assert_equal 2, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 258, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 2, solve2(EXAMPLE2)
  end

  def test_solve2_input
    assert_equal 53, solve2(read_file('input.txt'))
  end
end
