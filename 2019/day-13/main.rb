# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end
require_relative '../intcode'

def tiles(outputs)
  outputs.each_slice(3).to_a
end

def solve(input)
  tiles(Intcode.new(input).run).count { it[2] == 2 }
end

# Plays the game by keeping the paddle under the ball; returns the final score.
def solve2(input)
  vm = Intcode.new(input)
  vm.mem[0] = 2
  score = ball = paddle = 0
  joystick = []
  until vm.halted?
    tiles(vm.run(joystick)).each do |x, y, v|
      if x == -1 && y.zero? then score = v
      elsif v == 3 then paddle = x
      elsif v == 4 then ball = x
      end
    end
    joystick = [ball <=> paddle]
  end
  score
end

class AoCTest < Minitest::Test
  def test_solve_example
    assert_equal [[1, 2, 3], [6, 5, 4]], tiles([1, 2, 3, 6, 5, 4])
  end

  def test_solve_input
    assert_equal 363, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 17_159, solve2(read_file('input.txt'))
  end
end
