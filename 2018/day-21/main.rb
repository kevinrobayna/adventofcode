# frozen_string_literal: true

require_relative '../../lib/aoc'
require_relative '../device'

# Value the halting check (the only eqrr against register 0) compares register 0 with, the first
# time it is reached: setting r0 to it halts the program after the fewest instructions.
def solve(input)
  ip_reg, program = Device.parse(input)
  check = program.index { |op, a, b, _| op == :eqrr && (a.zero? || b.zero?) }
  _, a, b, = program[check]
  value = nil
  Device.run(ip_reg, program) do |ip, regs|
    next unless ip == check

    value = regs[a.zero? ? b : a]
    :halt
  end
  value
end

# Native version of the hashing loop; yields each value checked against r0, in order.
def checked_values(input)
  _, program = Device.parse(input)
  bori = program.index { |op, _, b, _| op == :bori && b == 65_536 }
  seed = program[bori + 1][1]
  mult = program.find { |op, _, b, _| op == :muli && b > 256 }[2]
  x = 0
  loop do
    y = x | 65_536
    x = seed
    loop do
      x = (((x + (y & 255)) & 0xFFFFFF) * mult) & 0xFFFFFF
      break if y < 256

      y /= 256
    end
    yield x
  end
end

# Last new value before the sequence repeats: the r0 that halts after the most instructions.
def solve2(input)
  seen = Set.new
  last = nil
  checked_values(input) do |v|
    return last unless seen.add?(v)

    last = v
  end
end

class AoCTest < Minitest::Test
  def test_native_matches_elfcode
    input = read_file('input.txt')
    checked_values(input) { |v| return assert_equal(solve(input), v) }
  end

  def test_solve_input
    assert_equal 8_797_248, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 3_007_673, solve2(read_file('input.txt'))
  end
end
