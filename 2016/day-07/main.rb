# frozen_string_literal: true

require_relative '../../lib/aoc'

# Returns [supernet parts, hypernet parts].
def split_address(line)
  parts = line.split(/[\[\]]/)
  [parts.each_slice(2).map(&:first), parts.each_slice(2).filter_map { |s| s[1] }]
end

def abba?(s) = s.chars.each_cons(4).any? { |a, b, c, d| a == d && b == c && a != b }

def abas(s) = s.chars.each_cons(3).select { |a, b, c| a == c && a != b }

def tls?(line)
  outside, inside = split_address(line)
  outside.any? { |s| abba?(s) } && inside.none? { |s| abba?(s) }
end

def ssl?(line)
  outside, inside = split_address(line)
  babs = outside.flat_map { |s| abas(s) }.map { |a, b, _| "#{b}#{a}#{b}" }
  babs.any? { |bab| inside.any? { |s| s.include?(bab) } }
end

def addresses(input) = input.lines.map(&:strip).reject(&:empty?)

def solve(input)
  addresses(input).count { |l| tls?(l) }
end

def solve2(input)
  addresses(input).count { |l| ssl?(l) }
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    abba[mnop]qrst
    abcd[bddb]xyyx
    aaaa[qwer]tyui
    ioxxoj[asdfgh]zxcvbn
  INPUT

  EXAMPLE2 = <<~INPUT
    aba[bab]xyz
    xyx[xyx]xyx
    aaa[kek]eke
    zazbz[bzb]cdb
  INPUT

  def test_solve_example
    assert_equal 2, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 118, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 3, solve2(EXAMPLE2)
  end

  def test_solve2_input
    assert_equal 260, solve2(read_file('input.txt'))
  end
end
