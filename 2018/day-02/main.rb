# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def solve(input)
  tallies = input.lines(chomp: true).map { |id| id.chars.tally.values }
  tallies.count { |t| t.include?(2) } * tallies.count { |t| t.include?(3) }
end

def solve2(input)
  ids = input.lines(chomp: true)
  ids.combination(2) do |a, b|
    diff = a.chars.each_index.reject { |i| a[i] == b[i] }
    return a.dup.tap { |s| s.slice!(diff.first) } if diff.size == 1
  end
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    abcdef
    bababc
    abbcde
    abcccd
    aabcdd
    abcdee
    ababab
  INPUT

  EXAMPLE2 = <<~INPUT
    abcde
    fghij
    klmno
    pqrst
    fguij
    axcye
    wvxyz
  INPUT

  def test_solve_example
    assert_equal 12, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 6972, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 'fgij', solve2(EXAMPLE2)
  end

  def test_solve2_input
    assert_equal 'aixwcbzrmdvpsjfgllthdyoqe', solve2(read_file('input.txt'))
  end
end
