# frozen_string_literal: true

require_relative '../../lib/aoc'

def captcha(input, offset)
  digits = input.strip.chars.map(&:to_i)
  digits.each_with_index.sum { |d, i| d == digits[(i + offset) % digits.size] ? d : 0 }
end

def solve(input)
  captcha(input, 1)
end

def solve2(input)
  captcha(input, input.strip.size / 2)
end

class AoCTest < Minitest::Test
  def test_solve_example
    assert_equal 3, solve('1122')
    assert_equal 4, solve('1111')
    assert_equal 0, solve('1234')
    assert_equal 9, solve('91212129')
  end

  def test_solve2_example
    assert_equal 6, solve2('1212')
    assert_equal 0, solve2('1221')
    assert_equal 4, solve2('123425')
    assert_equal 12, solve2('123123')
    assert_equal 4, solve2('12131415')
  end

  def test_solve_input
    assert_equal 1171, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 1024, solve2(read_file('input.txt'))
  end
end
