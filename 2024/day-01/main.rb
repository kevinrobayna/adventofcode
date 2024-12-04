# frozen_string_literal: true

require 'pry'
require 'minitest/autorun'

def read_file(filename)
  # Get the directory of the currently executing script
  # Join the script directory with the filename
  # Read the content of the file
  File.read(File.join(__dir__, filename))
end

def solve(filename)
  left = []
  right = []
  read_file(filename).lines.map(&:chomp).map(&:split).each do |l, r|
    left << l.to_i
    right << r.to_i
  end

  left.sort!
  right.sort!

  left.each.with_index.sum do |l, i|
    (l - right[i]).abs
  end
end

def solve2(filename)
  left = []
  right = []
  read_file(filename).lines.map(&:chomp).map(&:split).each do |l, r|
    left << l.to_i
    right << r.to_i
  end

  group = right.tally

  left.sum do |l|
    l * (group[l] || 0)
  end
end

class AoCTest < Minitest::Test
  def test_solve
    assert_equal 11, solve('test.txt')
  end

  def test_solve2
    assert_equal 31, solve2('test.txt')
  end
end

puts 'Part1', solve('input.txt')
puts 'Part2', solve2('input.txt')
