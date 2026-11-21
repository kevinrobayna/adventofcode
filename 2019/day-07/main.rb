# frozen_string_literal: true

require_relative '../../lib/aoc'
require_relative '../intcode'

def thrust(program, phases)
  phases.reduce(0) { |signal, phase| Intcode.new(program).run(phase, signal).last }
end

def feedback_thrust(program, phases)
  amps = phases.map { Intcode.new(program) << it }
  signal = 0
  amps.each { |amp| signal = amp.run(signal).last || signal } until amps.last.halted?
  signal
end

def solve(input)
  program = Intcode.parse(input)
  (0..4).to_a.permutation.map { thrust(program, it) }.max
end

def solve2(input)
  program = Intcode.parse(input)
  (5..9).to_a.permutation.map { feedback_thrust(program, it) }.max
end

class AoCTest < Minitest::Test
  EXAMPLE = '3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0'
  EXAMPLE2 = '3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0'
  EXAMPLE3 = '3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0'
  FEEDBACK = '3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5'
  FEEDBACK2 = '3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,' \
              '54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10'

  def test_solve_example
    assert_equal 43_210, solve(EXAMPLE)
    assert_equal 54_321, solve(EXAMPLE2)
    assert_equal 65_210, solve(EXAMPLE3)
    assert_equal 43_210, thrust(Intcode.parse(EXAMPLE), [4, 3, 2, 1, 0])
  end

  def test_solve2_example
    assert_equal 139_629_729, solve2(FEEDBACK)
    assert_equal 18_216, solve2(FEEDBACK2)
    assert_equal 18_216, feedback_thrust(Intcode.parse(FEEDBACK2), [9, 7, 8, 5, 6])
  end
end
