# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def ranges(input)
  input.strip.split(',').map { |r| r.split('-').map(&:to_i) }
end

# Yields every number in lo..hi made of a block of digits repeated `reps` times.
def repeated_in_range(lo, hi, reps)
  (lo.to_s.size..hi.to_s.size).flat_map do |len|
    next [] unless (len % reps).zero?

    block = len / reps
    mult = ((10**len) - 1) / ((10**block) - 1)
    first = [10**(block - 1), (lo + mult - 1) / mult].max
    last = [(10**block) - 1, hi / mult].min
    (first..last).map { |b| b * mult }
  end
end

def invalid_sum(input, reps_for)
  ranges(input).sum do |lo, hi|
    reps_for.call(hi.to_s.size).flat_map { |reps| repeated_in_range(lo, hi, reps) }.uniq.sum
  end
end

def solve(input)
  invalid_sum(input, ->(_) { [2] })
end

def solve2(input)
  invalid_sum(input, ->(max_len) { (2..max_len).to_a })
end

class AoCTest < Minitest::Test
  EXAMPLE = '11-22,95-115,998-1012,1188511880-1188511890,222220-222224,' \
            '1698522-1698528,446443-446449,38593856-38593862,565653-565659,' \
            "824824821-824824827,2121212118-2121212124\n"

  def test_solve_example
    assert_equal 1_227_775_554, solve(EXAMPLE)
  end

  def test_solve2_example
    assert_equal 4_174_379_265, solve2(EXAMPLE)
  end

  def test_solve_input
    assert_equal 12_850_231_731, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 24_774_350_322, solve2(read_file('input.txt'))
  end
end
