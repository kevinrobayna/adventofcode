# frozen_string_literal: true

require_relative '../../lib/aoc'

def rotate_based(s, letter)
  i = s.index(letter)
  s.chars.rotate(-(1 + i + (i >= 4 ? 1 : 0))).join
end

def apply(s, line, reverse: false)
  s = s.dup
  case line
  when /swap position (\d+) with position (\d+)/
    x = ::Regexp.last_match(1).to_i
    y = ::Regexp.last_match(2).to_i
    s[x], s[y] = s[y], s[x]
  when /swap letter (\w) with letter (\w)/
    s.tr!("#{::Regexp.last_match(1)}#{::Regexp.last_match(2)}", "#{::Regexp.last_match(2)}#{::Regexp.last_match(1)}")
  when /rotate (left|right) (\d+) step/
    n = ::Regexp.last_match(2).to_i * (::Regexp.last_match(1) == 'left' ? 1 : -1)
    s = s.chars.rotate(reverse ? -n : n).join
  when /rotate based on position of letter (\w)/
    letter = ::Regexp.last_match(1)
    s = reverse ? (0...s.size).map { |n| s.chars.rotate(n).join }.find { |c| rotate_based(c, letter) == s } : rotate_based(s, letter)
  when /reverse positions (\d+) through (\d+)/
    x = ::Regexp.last_match(1).to_i
    y = ::Regexp.last_match(2).to_i
    s[x..y] = s[x..y].reverse
  when /move position (\d+) to position (\d+)/
    x, y = [::Regexp.last_match(1).to_i, ::Regexp.last_match(2).to_i].then { |a, b| reverse ? [b, a] : [a, b] }
    chars = s.chars
    chars.insert(y, chars.delete_at(x))
    s = chars.join
  end
  s
end

def solve(input, password: 'abcdefgh')
  input.lines.reduce(password) { |s, line| apply(s, line) }
end

def solve2(input, scrambled: 'fbgdceah')
  input.lines.reverse.reduce(scrambled) { |s, line| apply(s, line, reverse: true) }
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    swap position 4 with position 0
    swap letter d with letter b
    reverse positions 0 through 4
    rotate left 1 step
    move position 1 to position 4
    move position 3 to position 0
    rotate based on position of letter b
    rotate based on position of letter d
  INPUT

  def test_solve_example
    assert_equal 'decab', solve(EXAMPLE, password: 'abcde')
  end

  def test_solve_input
    assert_equal 'bdfhgeca', solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 'abcde', solve2(EXAMPLE, scrambled: 'decab')
  end

  def test_solve2_input
    assert_equal 'gdfcabeh', solve2(read_file('input.txt'))
  end

  def test_solve2_round_trip
    assert_equal 'fbgdceah', solve(read_file('input.txt'), password: solve2(read_file('input.txt')))
  end
end
