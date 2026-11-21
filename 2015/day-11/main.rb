# frozen_string_literal: true

require_relative '../../lib/aoc'

STRAIGHTS = Regexp.union(('a'..'x').map { |c| c + c.next + c.next.next })

def valid_password?(password)
  password.match?(STRAIGHTS) && !password.match?(/[iol]/) && password.scan(/(.)\1/).uniq.size >= 2
end

def next_password(password)
  password = password.strip.succ
  password = password.succ until valid_password?(password)
  password
end

def solve(input)
  next_password(input)
end

def solve2(input)
  next_password(next_password(input))
end

class AoCTest < Minitest::Test
  def test_valid_password
    refute valid_password?('hijklmmn')
    refute valid_password?('abbceffg')
    refute valid_password?('abbcegjk')
    assert valid_password?('abcdffaa')
  end

  def test_solve_example
    assert_equal 'abcdffaa', solve('abcdefgh')
    assert_equal 'ghjaabcc', solve('ghijklmn')
  end

  def test_solve_input
    assert_equal 'hxbxxyzz', solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 'hxcaabcc', solve2(read_file('input.txt'))
  end
end
