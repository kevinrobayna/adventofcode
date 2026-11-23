# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

SIZE = 300

def power(x, y, serial)
  rack = x + 10
  ((((rack * y) + serial) * rack / 100) % 10) - 5
end

# Summed-area table, (SIZE + 1)^2 flat array, index y * (SIZE + 1) + x.
def summed_area(serial)
  w = SIZE + 1
  sat = Array.new(w * w, 0)
  (1..SIZE).each do |y|
    (1..SIZE).each do |x|
      sat[(y * w) + x] = power(x, y, serial) + sat[((y - 1) * w) + x] + sat[(y * w) + x - 1] - sat[((y - 1) * w) + x - 1]
    end
  end
  sat
end

# Returns [total, x, y] of the best square of size s.
def best_square(sat, s)
  w = SIZE + 1
  best = [-Float::INFINITY, 0, 0]
  (s..SIZE).each do |y|
    row = y * w
    top = (y - s) * w
    (s..SIZE).each do |x|
      total = sat[row + x] - sat[top + x] - sat[row + x - s] + sat[top + x - s]
      best = [total, x - s + 1, y - s + 1] if total > best[0]
    end
  end
  best
end

def solve(input)
  _, x, y = best_square(summed_area(input.to_i), 3)
  "#{x},#{y}"
end

def solve2(input)
  sat = summed_area(input.to_i)
  total, x, y, s = (1..SIZE).map { |s| best_square(sat, s) + [s] }.max_by(&:first)
  total && "#{x},#{y},#{s}"
end

class AoCTest < Minitest::Test
  def test_power
    assert_equal 4, power(3, 5, 8)
    assert_equal(-5, power(122, 79, 57))
    assert_equal 0, power(217, 196, 39)
    assert_equal 4, power(101, 153, 71)
  end

  def test_solve_example
    assert_equal '33,45', solve('18')
    assert_equal '21,61', solve('42')
  end

  def test_solve_input
    assert_equal '243,68', solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal '90,269,16', solve2('18')
    assert_equal '232,251,12', solve2('42')
  end

  def test_solve2_input
    assert_equal '236,252,12', solve2(read_file('input.txt'))
  end
end
