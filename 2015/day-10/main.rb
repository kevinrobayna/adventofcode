# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def look_and_say(digits)
  digits.gsub(/(\d)\1*/) { |run| "#{run.length}#{run[0]}" }
end

def look_and_say_length(input, times)
  times.times.reduce(input.strip) { |digits, _| look_and_say(digits) }.length
end

def solve(input)
  look_and_say_length(input, 40)
end

def solve2(input)
  look_and_say_length(input, 50)
end

class AoCTest < Minitest::Test
  def test_solve_example
    assert_equal '11', look_and_say('1')
    assert_equal '21', look_and_say('11')
    assert_equal '1211', look_and_say('21')
    assert_equal '111221', look_and_say('1211')
    assert_equal '312211', look_and_say('111221')
    assert_equal 6, look_and_say_length('1', 5)
  end

  def test_solve_input
    assert_equal 492_982, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 6_989_950, solve2(read_file('input.txt'))
  end
end
