# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def parse(input)
  input.strip.chars.map(&:to_i)
end

def solve(input)
  blocks = []
  parse(input).each_with_index { |len, i| blocks.concat([i.even? ? i / 2 : nil] * len) }
  left = 0
  right = blocks.size - 1
  while left < right
    if blocks[left]
      left += 1
    elsif blocks[right].nil?
      right -= 1
    else
      blocks[left] = blocks[right]
      blocks[right] = nil
    end
  end
  blocks.each_with_index.sum { |id, pos| id.to_i * pos }
end

def solve2(input)
  files = []
  free = Array.new(10) { [] } # free span starts, sorted, indexed by span length
  pos = 0
  parse(input).each_with_index do |len, i|
    i.even? ? files << [pos, len] : (free[len] << pos if len.positive?)
    pos += len
  end

  checksum = 0
  files.each_with_index.reverse_each do |(start, len), id|
    size = (len..9).select { free[_1].first&.< start }.min_by { free[_1].first }
    if size
      start = free[size].shift
      rest = size - len
      if rest.positive?
        spans = free[rest]
        spans.insert(spans.bsearch_index { _1 > start + len } || spans.size, start + len)
      end
    end
    checksum += id * ((start * len) + ((len * (len - 1)) / 2))
  end
  checksum
end

class AoCTest < Minitest::Test
  EXAMPLE = "2333133121414131402\n"

  def test_solve_example
    assert_equal 1928, solve(EXAMPLE)
    assert_equal 60, solve('12345')
  end

  def test_solve2_example
    assert_equal 2858, solve2(EXAMPLE)
  end

  def test_solve_input
    assert_equal 6_395_800_119_709, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 6_418_529_470_362, solve2(read_file('input.txt'))
  end
end
