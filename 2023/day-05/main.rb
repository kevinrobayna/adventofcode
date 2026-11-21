# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def overlaps?(a, b)
  a.cover?(b.first) || b.cover?(a.first)
end

def intersection(a, b)
  [a.begin, b.begin].max..[a.max, b.end].min
end

# Returns seeds and, per map, a sorted list of [source_range, delta] covering 0..infinity.
def parse(input)
  seeds_block, *blocks = input.split("\n\n")
  seeds = seeds_block.scan(/\d+/).map(&:to_i)
  maps = blocks.map do |block|
    sorted = block.lines.drop(1).map do |line|
      dest, orig, range = line.scan(/\d+/).map(&:to_i)
      [orig...(orig + range), dest - orig]
    end.sort_by { |r, _| r.begin }
    min_range = sorted.first.first.begin
    max_range = sorted.last.first.end
    sorted.unshift([0...min_range, 0]) unless min_range.zero?
    sorted << [max_range...1_000_000_000_000, 0]
  end
  [seeds, maps]
end

def solve(input)
  seeds, maps = parse(input)
  seeds.map do |seed|
    maps.reduce(seed) do |value, ranges|
      value + (ranges.find { |range, _| range.include?(value) }&.last || 0)
    end
  end.min
end

def solve2(input)
  seeds, maps = parse(input)
  solution = Array.new(maps.length + 1) { Set.new }
  seeds.each_slice(2) do |seed_start, len|
    solution[0] << (seed_start...(seed_start + len))

    maps.each_with_index do |ranges, inx|
      solution[inx].each do |range|
        solution[inx + 1] += ranges.filter_map do |rng, delta|
          next unless overlaps?(rng, range)

          better_range = intersection(rng, range)
          (better_range.begin + delta)...(better_range.end + delta)
        end
      end
    end
  end

  solution.last.map(&:begin).min
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    seeds: 79 14 55 13

    seed-to-soil map:
    50 98 2
    52 50 48

    soil-to-fertilizer map:
    0 15 37
    37 52 2
    39 0 15

    fertilizer-to-water map:
    49 53 8
    0 11 42
    42 0 7
    57 7 4

    water-to-light map:
    88 18 7
    18 25 70

    light-to-temperature map:
    45 77 23
    81 45 19
    68 64 13

    temperature-to-humidity map:
    0 69 1
    1 0 69

    humidity-to-location map:
    60 56 37
    56 93 4
  INPUT

  def test_solve_example
    assert_equal 35, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 175_622_908, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 46, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 5_200_543, solve2(read_file('input.txt'))
  end
end
