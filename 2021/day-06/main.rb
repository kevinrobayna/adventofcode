# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def simulate(input, days)
  timers = Array.new(9, 0)
  input.scan(/\d+/).each { |n| timers[n.to_i] += 1 }
  days.times do
    spawning = timers.shift
    timers[6] += spawning
    timers << spawning
  end
  timers.sum
end

def solve(input, days: 80)
  simulate(input, days)
end

def solve2(input)
  simulate(input, 256)
end

class AoCTest < Minitest::Test
  EXAMPLE = "3,4,3,1,2\n"

  def test_solve_example
    assert_equal 26, solve(EXAMPLE, days: 18)
    assert_equal 5934, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 386_755, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 26_984_457_539, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 1_732_731_810_807, solve2(read_file('input.txt'))
  end
end
