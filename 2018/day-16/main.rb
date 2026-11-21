# frozen_string_literal: true

require_relative '../../lib/aoc'
require_relative '../device'

def samples(input)
  input.scan(/Before:\s*\[(.*?)\]\n(.*?)\nAfter:\s*\[(.*?)\]/).map do |before, instr, after|
    [before.split(',').map(&:to_i), instr.split.map(&:to_i), after.split(',').map(&:to_i)]
  end
end

def candidates(before, instr, after)
  _, a, b, c = instr
  Device::OPS.keys.select { |op| Device.execute(before.dup, op, a, b, c) == after }
end

def solve(input)
  samples(input).count { |s| candidates(*s).size >= 3 }
end

def solve2(input)
  possible = Hash.new { |h, k| h[k] = Device::OPS.keys }
  samples(input).each { |s| possible[s[1][0]] &= candidates(*s) }
  opcodes = {}
  until possible.empty?
    code, ops = possible.find { |_, o| o.size == 1 }
    op = ops.first
    opcodes[code] = op
    possible.delete(code)
    possible.each_value { |ops| ops.delete(op) }
  end
  program = input.split("\n\n\n").last.lines.map { |l| l.split.map(&:to_i) }.reject(&:empty?)
  regs = [0, 0, 0, 0]
  program.each { |code, a, b, c| Device.execute(regs, opcodes[code], a, b, c) }
  regs[0]
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    Before: [3, 2, 1, 1]
    9 2 1 2
    After:  [3, 2, 2, 1]
  INPUT

  def test_candidates_example
    assert_equal %i[addi mulr seti], candidates(*samples(EXAMPLE).first).sort
  end

  def test_solve_example
    assert_equal 1, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 612, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 485, solve2(read_file('input.txt'))
  end
end
