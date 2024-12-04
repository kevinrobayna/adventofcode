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
  read_file(filename).lines.map(&:split).count { safe?(_1) }
end

def solve2(filename)
  read_file(filename).lines.map(&:split).count do |line|
    without_changes = safe?(line)

    with_changes = line.map.with_index do |_, inx|
      safe?(line.reject.with_index { |_, i| i == inx })
    end.any?

    without_changes || with_changes
  end
end

def safe?(line)
  line = line.map(&:to_i)
  is_sorted = line.sort == line || line.sort.reverse == line

  line_check = []
  array = line.sort.reverse
  array.each_with_index do |n, inx|
    next if inx == array.size - 1

    n_plus = array[inx + 1]

    line_check << n - n_plus
  end

  safe_increases = line_check.all? { [1, 2, 3].include?(_1) }

  is_sorted && safe_increases
end

class AoCTest < Minitest::Test
  def test_is_safe
    assert safe?(%w[7 6 4 2 1])
    assert safe?(%w[1 3 6 7 9])
  end

  def test_is_not_safe
    refute safe?(%w[1 2 7 8 9])
    refute safe?(%w[9 7 6 2 1])
    refute safe?(%w[1 3 2 4 5])
    refute safe?(%w[8 6 4 4 1])
  end

  def test_solve
    assert_equal 2, solve('test.txt')
  end

  def test_solve2
    assert_equal 4, solve2('test.txt')
  end
end

puts 'Part1', solve('input.txt')
puts 'Part2', solve2('input.txt')
