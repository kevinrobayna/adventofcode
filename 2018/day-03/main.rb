# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def claims(input)
  input.lines.map { |l| l.scan(/\d+/).map(&:to_i) }
end

def fabric(claims)
  counts = Hash.new(0)
  claims.each do |_, x, y, w, h|
    (x...(x + w)).each { |i| (y...(y + h)).each { |j| counts[[i, j]] += 1 } }
  end
  counts
end

def solve(input)
  fabric(claims(input)).count { |_, v| v > 1 }
end

def solve2(input)
  cs = claims(input)
  counts = fabric(cs)
  cs.find do |_, x, y, w, h|
    (x...(x + w)).all? { |i| (y...(y + h)).all? { |j| counts[[i, j]] == 1 } }
  end.first
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    #1 @ 1,3: 4x4
    #2 @ 3,1: 4x4
    #3 @ 5,5: 2x2
  INPUT

  def test_solve_example
    assert_equal 4, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 115_304, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 3, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 275, solve2(read_file('input.txt'))
  end
end
