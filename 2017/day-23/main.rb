# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def parse_program(input)
  input.lines.map(&:split).reject(&:empty?)
end

# Runs the coprocessor program; stops early once `pc` reaches `stop_at`. Returns [registers, mul count].
def run_coprocessor(program, a: 0, stop_at: nil)
  regs = Hash.new(0)
  regs['a'] = a
  val = ->(x) { /-?\d/.match?(x) ? x.to_i : regs[x] }
  pc = 0
  muls = 0
  while pc.between?(0, program.size - 1) && pc != stop_at
    op, x, y = program[pc]
    case op
    when 'set' then regs[x] = val[y]
    when 'sub' then regs[x] -= val[y]
    when 'mul'
      regs[x] *= val[y]
      muls += 1
    when 'jnz' then pc += val[y] - 1 unless val[x].zero?
    end
    pc += 1
  end
  [regs, muls]
end

def prime?(n)
  n >= 2 && (2..Integer.sqrt(n)).none? { |d| (n % d).zero? }
end

def composites(from, to, step)
  from.step(to, step).count { |n| !prime?(n) }
end

def solve(input)
  run_coprocessor(parse_program(input))[1]
end

# With a=1 the program counts the composite numbers in b..c stepping by the constant in the
# second-to-last instruction ("sub b -17"). Run only the setup (up to "set f 1") to get b and c.
def solve2(input)
  program = parse_program(input)
  setup_end = program.index(%w[set f 1])
  regs, = run_coprocessor(program, a: 1, stop_at: setup_end)
  composites(regs['b'], regs['c'], -program[-2][2].to_i)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    set a 3
    sub a 1
    mul b 2
    jnz a -2
  INPUT

  def test_solve_example
    assert_equal 3, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 5_929, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 7, composites(10, 20, 1)
    assert_equal 2, composites(9, 25, 8)
  end

  def test_solve2_input
    assert_equal 907, solve2(read_file('input.txt'))
  end
end
