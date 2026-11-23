# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def triangle?(sides)
  a, b, c = sides.sort
  a + b > c
end

def parse(input) = input.lines.map { |l| l.split.map(&:to_i) }.reject(&:empty?)

def solve(input)
  parse(input).count { |t| triangle?(t) }
end

def solve2(input)
  parse(input).each_slice(3).flat_map(&:transpose).count { |t| triangle?(t) }
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    101 301 501
    102 302 502
    103 303 503
    201 401 601
    202 402 602
    203 403 603
  INPUT

  def test_solve_example
    assert_equal 0, solve('5 10 25')
    assert_equal 3, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 982, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 6, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 1826, solve2(read_file('input.txt'))
  end
end
