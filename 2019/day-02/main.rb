# frozen_string_literal: true

require_relative '../../lib/aoc'
require_relative '../intcode'

def run_program(program, noun = nil, verb = nil)
  vm = Intcode.new(program)
  vm.mem[1] = noun if noun
  vm.mem[2] = verb if verb
  vm.run
  vm.mem[0]
end

def solve(input, noun: 12, verb: 2)
  run_program(Intcode.parse(input), noun, verb)
end

def solve2(input, target: 19_690_720)
  program = Intcode.parse(input)
  (0..99).to_a.product((0..99).to_a).each do |noun, verb|
    return (100 * noun) + verb if run_program(program, noun, verb) == target
  end
  nil
end

class AoCTest < Minitest::Test
  def test_solve_example
    assert_equal 3500, solve('1,9,10,3,2,3,11,0,99,30,40,50', noun: 9, verb: 10)
    assert_equal 2, solve('1,0,0,0,99', noun: 0, verb: 0)
    assert_equal 30, run_program(Intcode.parse('1,1,1,4,99,5,6,0,99'))
  end

  def test_intcode_writes
    vm = Intcode.new('2,4,4,5,99,0')
    vm.run

    assert_equal 9801, vm.mem[5]
  end

  def test_solve_input
    assert_equal 3_224_742, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 1202, solve2(read_file('input.txt'), target: solve(read_file('input.txt')))
  end

  def test_solve2_input
    assert_equal 7960, solve2(read_file('input.txt'))
  end
end
