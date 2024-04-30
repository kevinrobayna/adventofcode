# frozen_string_literal: true

require "pry"

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

def solve(filename, n_folds = 1)
  read_file(filename).each_line.reduce(0) do |acc, line|
    springs, rules = line.strip.split(" ")

    # Expand the number of folds
    # Replace multiple instances of . with a single . since .. == .
    # Append a . to the end of the input to not need to worry about '# 1' being invalid
    springs = "#{([springs] * n_folds).join("?")}.".squeeze(".")
    rules = rules.split(",").map(&:to_i) * n_folds

    acc + count(springs, rules, 0, {})
  end
end

def count(springs, rules, group_count = 0, cache = {})
  key = [springs, rules, group_count]

  return cache[key] if cache[key]

  return cache[key] = 0 if rules.any? { _1 - group_count > springs.length }

  if rules.empty?
    return cache[key] = 1 unless springs.include?("#")

    return cache[key] = 0
  end

  head, *left = springs.chars
  case [head, group_count]
  in ["?", _]
    # Explore solution for either value of ?
    cache[key] =
      count("##{left.join}", rules, group_count, cache) + count(".#{left.join}", rules, group_count, cache)
  in ["#", _]
    cache[key] = count(left.join, rules, group_count + 1, cache)
  in [".", ^(rules.first)]
    # We finished completing a group
    cache[key] = count(left.join, rules[1..], 0, cache)
  in [".", (1..)]
    # we found a . but the group count does not match so this combination is invalid
    cache[key] = 0
  in [".", 0]
    # Move forward
    cache[key] = count(left.join, rules, 0, cache)
  end
end

compare_solutions(21, solve("test.txt"))
puts "Part1", solve("input.txt")

compare_solutions(525_152, solve("test.txt", 5))
puts "Part2", solve("input.txt", 5)
