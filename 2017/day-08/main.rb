# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

# Returns [largest register value at the end, largest value ever held].
def run_registers(input)
  regs = Hash.new(0)
  highest = 0
  input.each_line do |line|
    reg, op, amount, _if, cond_reg, cmp, value = line.split
    next unless reg && regs[cond_reg].public_send(cmp, value.to_i)

    regs[reg] += op == 'inc' ? amount.to_i : -amount.to_i
    highest = [highest, regs[reg]].max
  end
  [regs.values.max || 0, highest]
end

def solve(input)
  run_registers(input)[0]
end

def solve2(input)
  run_registers(input)[1]
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    b inc 5 if a > 1
    a inc 1 if b < 5
    c dec -10 if a >= 1
    c inc -20 if c == 10
  INPUT

  def test_solve_example
    assert_equal 1, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 5_752, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 10, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 6_366, solve2(read_file('input.txt'))
  end
end
