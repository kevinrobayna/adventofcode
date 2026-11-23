# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

# A lock and key fit when no column has '#' in both schematics.
def solve(input)
  locks, keys = input.split("\n\n").map { _1.delete("\n") }.partition { _1.start_with?('#') }
  locks.sum do |lock|
    keys.count { |key| lock.each_char.zip(key.each_char).none? { |a, b| a == '#' && b == '#' } }
  end
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    #####
    .####
    .####
    .####
    .#.#.
    .#...
    .....

    #####
    ##.##
    .#.##
    ...##
    ...#.
    ...#.
    .....

    .....
    #....
    #....
    #...#
    #.#.#
    #.###
    #####

    .....
    .....
    #.#..
    ###..
    ###.#
    ###.#
    #####

    .....
    .....
    .....
    #....
    #.#..
    #.#.#
    #####
  INPUT

  def test_solve_example
    assert_equal 3, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 3162, solve(read_file('input.txt'))
  end
end
