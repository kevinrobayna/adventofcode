# frozen_string_literal: true

require_relative '../../lib/aoc'

def parse(input)
  input.lines.map do |l|
    op, arg = l.split
    [op, arg.to_i]
  end
end

# Returns [terminated?, acc]
def run_program(program)
  acc = 0
  pc = 0
  seen = Set.new
  while pc < program.size
    return [false, acc] unless seen.add?(pc)

    op, arg = program[pc]
    case op
    when 'acc' then acc += arg
    when 'jmp' then pc += arg - 1
    end
    pc += 1
  end
  [true, acc]
end

def solve(input)
  run_program(parse(input))[1]
end

def solve2(input)
  program = parse(input)
  program.each_index do |i|
    op, arg = program[i]
    next if op == 'acc'

    patched = program.dup
    patched[i] = [op == 'jmp' ? 'nop' : 'jmp', arg]
    done, acc = run_program(patched)
    return acc if done
  end
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    nop +0
    acc +1
    jmp +4
    acc +3
    jmp -3
    acc -99
    acc +1
    jmp -4
    acc +6
  INPUT

  def test_solve_example
    assert_equal 5, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 1814, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 8, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 1056, solve2(read_file('input.txt'))
  end
end
