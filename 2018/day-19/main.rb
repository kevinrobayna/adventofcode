# frozen_string_literal: true

require_relative '../../lib/aoc'
require_relative '../device'

def solve(input)
  Device.run(*Device.parse(input))[0]
end

# The program computes the sum of the divisors of a large number. Run the setup phase until the
# program jumps back to the start of its main loop (ip 1), then compute the sum directly.
def solve2(input, r0: 1)
  ip_reg, program = Device.parse(input)
  regs = [r0, 0, 0, 0, 0, 0]
  started = false
  Device.run(ip_reg, program, regs) do |ip, _|
    next :halt if started && ip == 1

    started ||= ip != 0
    nil
  end
  n = regs.max
  (1..Integer.sqrt(n)).select { |d| (n % d).zero? }.flat_map { |d| [d, n / d] }.uniq.sum
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    #ip 0
    seti 5 0 1
    seti 6 0 2
    addi 0 1 0
    addr 1 2 3
    setr 1 0 0
    seti 8 0 4
    seti 9 0 5
  INPUT

  def test_solve_example
    assert_equal 6, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 1848, solve(read_file('input.txt'))
  end

  def test_divisor_shortcut_matches_simulation
    assert_equal solve(read_file('input.txt')), solve2(read_file('input.txt'), r0: 0)
  end

  def test_solve2_input
    assert_equal 22_157_688, solve2(read_file('input.txt'))
  end
end
