# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def open?(x, y, fav)
  x >= 0 && y >= 0 && ((x * x) + (3 * x) + (2 * x * y) + y + (y * y) + fav).digits(2).sum.even?
end

# BFS from (1,1); returns { [x, y] => distance } for every cell reached within max_steps.
def distances(fav, max_steps: Float::INFINITY, target: nil)
  dist = { [1, 1] => 0 }
  frontier = [[1, 1]]
  steps = 0
  until frontier.empty? || steps >= max_steps || (target && dist.key?(target))
    steps += 1
    frontier = frontier.flat_map do |x, y|
      [[x + 1, y], [x - 1, y], [x, y + 1], [x, y - 1]].select do |nx, ny|
        open?(nx, ny, fav) && !dist.key?([nx, ny]) && (dist[[nx, ny]] = steps)
      end
    end
  end
  dist
end

def solve(input, target: [31, 39])
  distances(input.to_i, target:)[target]
end

def solve2(input, steps: 50)
  distances(input.to_i, max_steps: steps).size
end

class AoCTest < Minitest::Test
  def test_solve_example
    assert_equal 11, solve('10', target: [7, 4])
  end

  def test_solve_input
    assert_equal 82, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 3, solve2('10', steps: 1)
    assert_equal 5, solve2('10', steps: 2)
  end

  def test_solve2_input
    assert_equal 138, solve2(read_file('input.txt'))
  end
end
