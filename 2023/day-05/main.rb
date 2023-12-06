# frozen_string_literal: true

require 'pry'

class Range
  def overlaps?(other)
    cover?(other.first) || other.cover?(first)
  end

  def intersection(other)
    return nil if max < other.begin || other.max < self.begin

    [self.begin, other.begin].max..[max, other.end].min
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
      dest, orig, range = line.scan(/\d+/).map(&:to_i)
      map_info[map_key.to_sym] << [orig...(orig + range), dest - orig]
    elsif map_key != ''
      sorted = map_info[map_key.to_sym].sort_by { |r, _d| r.begin }
      min_range = sorted.first.first.begin
      max_range = sorted.last.first.end
      sorted.unshift([0...min_range, 0]) unless min_range.zero?
      sorted << [max_range...1_000_000_000_000, 0]

      map_info[map_key.to_sym] = sorted
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
      delta = values.filter { |range, _| range.include?(seed_value) }.map(&:last).first || 0
      seed_value += delta
    end
    seed_value
  end.min
end

def solve2(filename)
  seeds, info = parse_file(filename)
  solution = Array.new(info.keys.length + 1) { Set.new }
  seeds.each_slice(2) do |seed_start, len|
    seed_range = (seed_start...(seed_start + len))
    solution[0] << seed_range

    info.values.each_with_index do |values, inx|
      solution[inx].each do |range|
        solution[inx + 1] += values.filter_map do |rng, delta|
          if rng.overlaps?(range)
            better_range = (rng & range)
            ((better_range.begin + delta)...(better_range.end + delta))
          end
        end
      end
    end
  end

  solution.last.map(&:begin).min
end

compare_solutions(35, solve('test.txt'))
puts 'Part1', solve('input.txt')

compare_solutions(46, solve2('test.txt'))
puts 'Part2', solve2('input.txt')
