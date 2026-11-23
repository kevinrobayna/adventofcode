# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

# Returns { guard_id => Array(60) of minute sleep counts }
def sleep_minutes(input)
  guards = Hash.new { |h, k| h[k] = Array.new(60, 0) }
  guard = nil
  asleep = nil
  input.lines.sort.each do |line|
    minute = line[/:(\d\d)\]/, 1].to_i
    case line
    when /#(\d+)/ then guard = Regexp.last_match(1).to_i
    when /falls asleep/ then asleep = minute
    when /wakes up/ then (asleep...minute).each { |m| guards[guard][m] += 1 }
    end
  end
  guards
end

def strategy(input)
  id, minutes = sleep_minutes(input).max_by { |_, mins| yield mins }
  id * minutes.each_with_index.max.last
end

def solve(input)
  strategy(input, &:sum)
end

def solve2(input)
  strategy(input, &:max)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    [1518-11-01 00:00] Guard #10 begins shift
    [1518-11-01 00:05] falls asleep
    [1518-11-01 00:25] wakes up
    [1518-11-01 00:30] falls asleep
    [1518-11-01 00:55] wakes up
    [1518-11-01 23:58] Guard #99 begins shift
    [1518-11-02 00:40] falls asleep
    [1518-11-02 00:50] wakes up
    [1518-11-03 00:05] Guard #10 begins shift
    [1518-11-03 00:24] falls asleep
    [1518-11-03 00:29] wakes up
    [1518-11-04 00:02] Guard #99 begins shift
    [1518-11-04 00:36] falls asleep
    [1518-11-04 00:46] wakes up
    [1518-11-05 00:03] Guard #99 begins shift
    [1518-11-05 00:45] falls asleep
    [1518-11-05 00:55] wakes up
  INPUT

  def test_solve_example
    assert_equal 240, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 106_710, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 4455, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 10_491, solve2(read_file('input.txt'))
  end
end
