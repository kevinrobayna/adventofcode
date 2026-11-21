# frozen_string_literal: true

require_relative '../../lib/aoc'

def parse_program(input)
  input.lines.map { |line| line.strip.split(/,?\s+/) }
end

def run_program(input, registers)
  program = parse_program(input)
  pc = 0
  while pc.between?(0, program.size - 1)
    op, x, y = program[pc]
    offset = 1
    case op
    when 'hlf' then registers[x] /= 2
    when 'tpl' then registers[x] *= 3
    when 'inc' then registers[x] += 1
    when 'jmp' then offset = x.to_i
    when 'jie' then offset = y.to_i if registers[x].even?
    when 'jio' then offset = y.to_i if registers[x] == 1
    end
    pc += offset
  end
  registers
end

def solve(input, register: 'b')
  run_program(input, { 'a' => 0, 'b' => 0 })[register]
end

def solve2(input, register: 'b')
  run_program(input, { 'a' => 1, 'b' => 0 })[register]
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    inc a
    jio a, +2
    tpl a
    inc a
  INPUT

  def test_solve_example
    assert_equal 2, solve(EXAMPLE, register: 'a')
  end

  def test_solve_input
    assert_equal 255, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 7, solve2(EXAMPLE, register: 'a')
  end

  def test_solve2_input
    assert_equal 334, solve2(read_file('input.txt'))
  end
end
