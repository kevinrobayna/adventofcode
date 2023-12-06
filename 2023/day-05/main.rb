# frozen_string_literal: true

require 'pry'

class Range
  def overlaps?(other)
    cover?(other.first) || other.cover?(first)
  end

  def intersection(other)
    return nil if max < other.begin || other.max < self.begin

    [self.begin, other.begin].max..[max, other.max].min
  end

  alias & intersection
end

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
  seeds = []
  map_info = {}
  map_key = ''
  read_file(filename).each_line do |line|
    if line.match('seeds:')
      seeds = line.scan(/\d+/).map(&:to_i)
    elsif line.match(/(.*)\smap:/)
      map_key = line.match(/(.*)\smap:/)[1]
      map_info[map_key.to_sym] = []
    elsif line.match(/\d+\s\d+\s\d+/)
      map_info[map_key.to_sym] << line.scan(/\d+/).map(&:to_i)
    else
      map_key = ''
    end
  end
  [seeds, map_info]
end

def solve(filename)
  seeds, map_info = parse_file(filename)
  seeds.map do |seed|
    seed_value = seed
    map_info.each_value do |values|
      translation = values.select do |_dest, orig, range|
        (orig...(orig + range)).include? seed_value
      end
      next if translation.empty?

      dest, orig, _range = translation.first
      seed_value = dest + (seed_value - orig)
    end
    seed_value
  end.min
end

def solve2(filename)
  parse_file(filename)
  0
end

compare_solutions(35, solve('test.txt'))
puts 'Part1', solve('input.txt')

compare_solutions(46, solve2('test.txt'))
puts 'Part2', solve2('input.txt')
