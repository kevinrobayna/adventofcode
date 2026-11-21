# frozen_string_literal: true

require_relative '../../lib/aoc'

def parse(input)
  a, b, c, *program = input.scan(/\d+/).map(&:to_i)
  [[a, b, c], program]
end

def execute(registers, program)
  a, b, c = registers
  ip = 0
  out = []
  while ip < program.size
    opcode = program[ip]
    literal = program[ip + 1]
    combo = [0, 1, 2, 3, a, b, c][literal]
    case opcode
    when 0 then a >>= combo
    when 1 then b ^= literal
    when 2 then b = combo % 8
    when 3 then (ip = literal - 2) unless a.zero?
    when 4 then b ^= c
    when 5 then out << (combo % 8)
    when 6 then b = a >> combo
    when 7 then c = a >> combo
    end
    ip += 2
  end
  out
end

def solve(input)
  execute(*parse(input)).join(',')
end

# Puzzle programs loop `out(f(A)); A >>= 3` until A is 0, so A can be built three bits at a
# time from the last output backwards, keeping every candidate that reproduces the suffix.
def solve2(input)
  (_, b, c), program = parse(input)
  candidates = [0]
  program.size.times do |i|
    suffix = program[-(i + 1)..]
    candidates = candidates.flat_map { |base| (0..7).map { (base * 8) + _1 } }
                           .select { |a| execute([a, b, c], program) == suffix }
  end
  candidates.select(&:positive?).min
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    Register A: 729
    Register B: 0
    Register C: 0

    Program: 0,1,5,4,3,0
  INPUT

  EXAMPLE2 = <<~INPUT
    Register A: 2024
    Register B: 0
    Register C: 0

    Program: 0,3,5,4,3,0
  INPUT

  def test_instructions
    assert_equal [0, 1, 2], execute([10, 0, 0], [5, 0, 5, 1, 5, 4])
    assert_equal [4, 2, 5, 6, 7, 7, 7, 7, 3, 1, 0], execute([2024, 0, 0], [0, 1, 5, 4, 3, 0])
    assert_equal [1], execute([0, 0, 9], [2, 6, 5, 5])
  end

  def test_solve_example
    assert_equal '4,6,3,5,6,3,5,2,1,0', solve(EXAMPLE)
  end

  def test_solve2_example
    assert_equal 117_440, solve2(EXAMPLE2)
  end

  def test_solve2_typical_program
    program = '2,4,1,1,7,5,1,5,4,0,5,5,0,3,3,0'
    a = solve2("Register A: 1\nRegister B: 0\nRegister C: 0\n\nProgram: #{program}\n")
    assert_equal program, solve("Register A: #{a}\nRegister B: 0\nRegister C: 0\n\nProgram: #{program}\n")
  end

  def test_solve_input
    assert_equal '6,5,4,7,1,6,0,3,1', solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 106_086_382_266_778, solve2(read_file('input.txt'))
  end
end
