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
  regex = /mul\((\d+),(\d+)\)/
  read_file(filename).scan(regex).reduce(0) do |acc, (a, b)|
    acc += a.to_i * b.to_i
    acc
  end
end

def solve2(filename)
  regex = /(mul\((\d+),(\d+)\)|do\(\)|don't\(\))/
  matches = read_file(filename).scan(regex)

  found_don_t = false
  filtered_matches = matches.map do |match, f, s|
    if match == 'do()'
      found_don_t = false
      [match, 0]
    elsif match == "don't()"
      found_don_t = true
      [match, 0]
    elsif match.start_with?('mul')
      if found_don_t
        [match, 0]
      else
        [match, f.to_i * s.to_i]
      end
    else
      raise "Unknown match: #{match}"
    end
  end

  filtered_matches.sum { |(_, b)| b }
end

class AoCTest < Minitest::Test
  def test_solve
    assert_equal 161, solve('test.txt')
  end

  def test_solve2
    assert_equal 48, solve2('test.txt')
  end
end

puts 'Part1', solve('input.txt')
puts 'Part2', solve2('input.txt')
