# frozen_string_literal: true

require "json"

def compare_solutions(expected, actual)
  raise "Expected #{expected} but got #{actual}" unless expected == actual

  puts "Congratulations! Got expected result (#{expected})"
end

def read_file(filename)
  # Get the directory of the currently executing script
  # Join the script directory with the filename
  # Read the content of the file
  File.read(File.join(__dir__, filename))
end

def parse_file(filename)
  read_file(filename).each_line.reject { _1.strip.empty? }.map { JSON.parse(_1.strip) }
end

def solve(filename)
  signals = parse_file(filename)

  pair_inx = 1
  index_sum = []
  (0...signals.length).step(2).each do |signal|
    left = signals[signal]
    right = signals[signal + 1]
    puts "\n== Pair #{pair_inx} =="
    result = compare(left, right)
    index_sum << pair_inx if result.positive?
    pair_inx += 1
  end

  puts "\n== Results == [#{index_sum.join(", ")}]"
  index_sum.sum
end

def compare(left, right)
  puts "- Compare #{left} vs #{right}"
  if left.instance_of?(Integer) && right.instance_of?(Integer)
    if left < right
      puts "- Left side is smaller, so inputs are in the right order"
      return 1
    elsif left > right
      puts "- Right side is smaller, so inputs are not in the right order"
      return -1
    end
  elsif left.instance_of?(Array) && right.instance_of?(Array)
    (0...left.length).each do |i|
      break if left[i].nil? || right[i].nil?

      result = compare(left[i], right[i])
      return result if result.positive? || result.negative?
    end
    if left.length < right.length
      puts "- Left side ran out of items, so inputs are in the right order"
      return 1
    elsif left.length > right.length
      puts "- Right side ran out of items, so inputs are not in the right order"
      return -1
    end
  elsif left.instance_of?(Array) || right.instance_of?(Array)
    if left.instance_of?(Array)
      if right.nil?
        puts "- Right side ran out of items, so inputs are not in the right order"
        return -1
      end
      puts "- Mixed types; convert right to [#{right}] and retry comparison"
      result = compare(left, [right])
    else
      if left.nil?
        puts "- Left side ran out of items, so inputs are in the right order"
        return 1
      end
      puts "- Mixed types; convert left to [#{left}] and retry comparison"
      result = compare([left], right)
    end
    return result if result.positive? || result.negative?
  end
  0
end

def solve2(filename)
  signals = parse_file(filename)
  signals.push([[2]], [[6]])

  sorted = signals.sort do |a, b|
    result = compare(a, b)
    result.positive? ? -1 : 1
  end

  div_one = sorted.find_index([[2]]) + 1
  div_two = sorted.find_index([[6]]) + 1

  div_one * div_two
end

compare_solutions(13, solve("test.txt"))
puts "Part1", solve("input.txt")

compare_solutions(140, solve2("test.txt"))
puts "Part2", solve2("input.txt")
