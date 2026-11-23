# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

# Runs an ALU program on the given digits and returns the registers.
def run_alu(program, inputs)
  regs = { 'w' => 0, 'x' => 0, 'y' => 0, 'z' => 0 }
  inputs = inputs.dup
  program.split("\n").each do |line|
    op, a, b = line.split
    value = b && (regs.key?(b) ? regs[b] : b.to_i)
    case op
    when 'inp' then regs[a] = inputs.shift
    when 'add' then regs[a] += value
    when 'mul' then regs[a] *= value
    when 'div' then regs[a] = regs[a].fdiv(value).truncate
    when 'mod' then regs[a] %= value
    when 'eql' then regs[a] = regs[a] == value ? 1 : 0
    end
  end
  regs
end

# The program is 14 blocks; each either pushes (input + offset) on a base-26 stack (div z 1) or pops
# and requires input == top + check (div z 26). Pairing pushes with pops gives digit constraints.
def model_number(program, largest:)
  blocks = program.split("inp w\n").reject(&:empty?).map(&:lines)
  digits = Array.new(14)
  stack = []
  blocks.each_with_index do |block, i|
    pops = block[3].split.last == '26'
    check = block[4].split.last.to_i
    offset = block[14].split.last.to_i
    unless pops
      stack.push([i, offset])
      next
    end

    j, push_offset = stack.pop
    diff = push_offset + check # digits[i] = digits[j] + diff
    digits[j] = largest ? [9, 9 - diff].min : [1, 1 - diff].max
    digits[i] = digits[j] + diff
  end
  raise 'Invalid model number' unless run_alu(program, digits)['z'].zero?

  digits.join.to_i
end

def solve(input)
  model_number(input, largest: true)
end

def solve2(input)
  model_number(input, largest: false)
end

class AoCTest < Minitest::Test
  BINARY = <<~INPUT
    inp w
    add z w
    mod z 2
    div w 2
    add y w
    mod y 2
    div w 2
    add x w
    mod x 2
    div w 2
    mod w 2
  INPUT

  def test_run_alu_example
    assert_equal({ 'w' => 1, 'x' => 0, 'y' => 1, 'z' => 1 }, run_alu(BINARY, [11]))
    assert_equal(-7, run_alu("inp x\nmul x -1", [7])['x'])
  end

  def test_solve_input
    assert_equal 99_799_212_949_967, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 34_198_111_816_311, solve2(read_file('input.txt'))
  end
end
