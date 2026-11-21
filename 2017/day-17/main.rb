# frozen_string_literal: true

require_relative '../../lib/aoc'

RubyVM::YJIT.enable if defined?(RubyVM::YJIT)

def solve(input)
  step = input.to_i
  buffer = [0]
  pos = 0
  (1..2017).each do |n|
    pos = (pos + step) % n + 1
    buffer.insert(pos, n)
  end
  buffer[(pos + 1) % buffer.size]
end

# Value 0 stays at index 0, so only insertions at index 1 matter.
def solve2(input, insertions: 50_000_000)
  step = input.to_i
  pos = 0
  after_zero = nil
  (1..insertions).each do |n|
    pos = (pos + step) % n + 1
    after_zero = n if pos == 1
  end
  after_zero
end

class AoCTest < Minitest::Test
  def test_solve_example
    assert_equal 638, solve('3')
  end

  def test_solve_input
    assert_equal 725, solve(read_file('input.txt'))
  end

  def test_solve2_example
    # 0 (9) 5 7 2 4 3 8 6 1
    assert_equal 9, solve2('3', insertions: 9)
    assert_equal 5, solve2('3', insertions: 8)
  end

  def test_solve2_input
    assert_equal 27_361_412, solve2(read_file('input.txt'))
  end
end
