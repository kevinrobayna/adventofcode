# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end
require_relative '../intcode'

def solve(input, system_id: 1)
  Intcode.new(input).run(system_id).last
end

def solve2(input, system_id: 5)
  Intcode.new(input).run(system_id).last
end

class AoCTest < Minitest::Test
  LARGER = '3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,' \
           '999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99'

  def test_solve_example
    assert_equal 42, solve('3,0,4,0,99', system_id: 42)
    vm = Intcode.new('1002,4,3,4,33')
    vm.run

    assert_equal 99, vm.mem[4]
    assert_predicate vm, :halted?
  end

  def test_solve_input
    assert_equal 4_601_506, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 1, solve2('3,9,8,9,10,9,4,9,99,-1,8', system_id: 8)
    assert_equal 0, solve2('3,3,1107,-1,8,3,4,3,99', system_id: 9)
    assert_equal 0, solve2('3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9', system_id: 0)
    assert_equal 1, solve2('3,3,1105,-1,9,1101,0,0,12,4,12,99,1', system_id: 3)
    assert_equal([999, 1000, 1001], [7, 8, 9].map { solve2(LARGER, system_id: it) })
  end

  def test_solve2_input
    assert_equal 5_525_561, solve2(read_file('input.txt'))
  end
end
