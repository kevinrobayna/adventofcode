# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

# Cube coordinates for the hex directions.
HEX_STEPS = {
  'n' => [0, 1, -1], 's' => [0, -1, 1], 'ne' => [1, 0, -1],
  'sw' => [-1, 0, 1], 'nw' => [-1, 1, 0], 'se' => [1, -1, 0]
}.freeze

# Returns [final distance, furthest distance].
def hex_walk(input)
  pos = [0, 0, 0]
  furthest = 0
  input.strip.split(',').each do |dir|
    pos = pos.zip(HEX_STEPS.fetch(dir)).map(&:sum)
    furthest = [furthest, pos.map(&:abs).max].max
  end
  [pos.map(&:abs).max, furthest]
end

def solve(input)
  hex_walk(input)[0]
end

def solve2(input)
  hex_walk(input)[1]
end

class AoCTest < Minitest::Test
  def test_solve_example
    assert_equal 3, solve('ne,ne,ne')
    assert_equal 0, solve('ne,ne,sw,sw')
    assert_equal 2, solve('ne,ne,s,s')
    assert_equal 3, solve('se,sw,se,sw,sw')
  end

  def test_solve_input
    assert_equal 685, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 2, solve2('ne,ne,sw,sw')
    assert_equal 3, solve2('se,sw,se,sw,sw')
  end

  def test_solve2_input
    assert_equal 1_457, solve2(read_file('input.txt'))
  end
end
