# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

# Mixes the numbers; values may repeat, so we move original indices around instead of values.
def grove_coordinates(input, key: 1, rounds: 1)
  numbers = input.split.map { |n| n.to_i * key }
  order = (0...numbers.size).to_a
  rounds.times do
    numbers.each_with_index do |value, i|
      pos = order.index(i)
      order.delete_at(pos)
      order.insert((pos + value) % order.size, i)
    end
  end
  mixed = order.map { |i| numbers[i] }
  zero = mixed.index(0)
  [1000, 2000, 3000].sum { |offset| mixed[(zero + offset) % mixed.size] }
end

def solve(input)
  grove_coordinates(input)
end

def solve2(input)
  grove_coordinates(input, key: 811_589_153, rounds: 10)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    1
    2
    -3
    3
    -2
    0
    4
  INPUT

  def test_solve_example
    assert_equal 3, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 8721, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 1_623_178_306, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 831_878_881_825, solve2(read_file('input.txt'))
  end
end
