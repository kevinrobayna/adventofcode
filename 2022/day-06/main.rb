# frozen_string_literal: true

require_relative '../../lib/aoc'

def solve(input)
  marker_position(input.strip, 4)
end

def solve2(input)
  marker_position(input.strip, 14)
end

def marker_position(content, size)
  content.chars.each_cons(size).with_index do |window, inx|
    return inx + size if window.uniq.size == size
  end
  raise 'No solution found'
end

class AoCTest < Minitest::Test
  EXAMPLES = {
    'mjqjpqmgbljsphdztnvjfqwrcgsmlb' => [7, 19],
    'bvwbjplbgvbhsrlpgdmjqwftvncz' => [5, 23],
    'nppdvjthqldpwncqszvftbrmjlhg' => [6, 23],
    'nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg' => [10, 29],
    'zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw' => [11, 26]
  }.freeze

  def test_solve_example
    EXAMPLES.each { |input, (expected, _)| assert_equal expected, solve(input) }
  end

  def test_solve_input
    assert_equal 1542, solve(read_file('input.txt'))
  end

  def test_solve2_example
    EXAMPLES.each { |input, (_, expected)| assert_equal expected, solve2(input) }
  end

  def test_solve2_input
    assert_equal 3153, solve2(read_file('input.txt'))
  end
end
