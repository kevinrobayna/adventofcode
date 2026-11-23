# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def simulate(input, dims, cycles: 6)
  active = Set.new
  input.split.each_with_index do |row, y|
    row.chars.each_with_index { |c, x| active << [x, y, *Array.new(dims - 2, 0)] if c == '#' }
  end
  offsets = ([-1, 0, 1].repeated_permutation(dims).to_a - [Array.new(dims, 0)])
  cycles.times do
    counts = Hash.new(0)
    active.each do |cell|
      offsets.each { |o| counts[cell.zip(o).map(&:sum)] += 1 }
    end
    active = counts.each_with_object(Set.new) do |(cell, n), next_active|
      next_active << cell if n == 3 || (n == 2 && active.include?(cell))
    end
  end
  active.size
end

def solve(input)
  simulate(input, 3)
end

def solve2(input)
  simulate(input, 4)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    .#.
    ..#
    ###
  INPUT

  def test_solve_example
    assert_equal 112, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 211, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 848, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 1952, solve2(read_file('input.txt'))
  end
end
