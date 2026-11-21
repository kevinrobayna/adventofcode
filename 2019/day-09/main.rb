# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end
require_relative '../intcode'

def solve(input)
  Intcode.new(input).run(1).last
end

def solve2(input)
  Intcode.new(input).run(2).last
end

class AoCTest < Minitest::Test
  QUINE = '109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99'

  def test_solve_example
    assert_equal Intcode.parse(QUINE), Intcode.new(QUINE).run
    assert_equal 16, Intcode.new('1102,34915192,34915192,7,4,7,99,0').run.last.to_s.size
    assert_equal 1_125_899_906_842_624, Intcode.new('104,1125899906842624,99').run.last
  end

  def test_solve_input
    assert_equal 2_738_720_997, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 50_894, solve2(read_file('input.txt'))
  end
end
