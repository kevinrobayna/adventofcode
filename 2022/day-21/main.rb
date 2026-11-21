# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def parse_monkeys(input)
  input.each_line.to_h do |line|
    name, job = line.strip.split(': ')
    [name, job.match?(/\A-?\d+\z/) ? job.to_i : job.split]
  end
end

def evaluate(monkeys, name)
  job = monkeys[name]
  return job if job.is_a?(Integer)

  left, op, right = job
  evaluate(monkeys, left).to_r.public_send(op, evaluate(monkeys, right))
end

def depends_on_human?(monkeys, name)
  return true if name == 'humn'

  job = monkeys[name]
  job.is_a?(Array) && (depends_on_human?(monkeys, job[0]) || depends_on_human?(monkeys, job[2]))
end

# Walks down from `name` towards humn, inverting each operation so that `name` equals `target`.
def solve_for_human(monkeys, name, target)
  return target if name == 'humn'

  left, op, right = monkeys[name]
  if depends_on_human?(monkeys, left)
    known = evaluate(monkeys, right)
    inverse = { '+' => target - known, '-' => target + known, '*' => target / known, '/' => target * known }
    solve_for_human(monkeys, left, inverse[op])
  else
    known = evaluate(monkeys, left)
    inverse = { '+' => target - known, '-' => known - target, '*' => target / known, '/' => known / target }
    solve_for_human(monkeys, right, inverse[op])
  end
end

def solve(input)
  evaluate(parse_monkeys(input), 'root').to_i
end

def solve2(input)
  monkeys = parse_monkeys(input)
  left, _, right = monkeys['root']
  human_side, other = depends_on_human?(monkeys, left) ? [left, right] : [right, left]
  solve_for_human(monkeys, human_side, evaluate(monkeys, other).to_r).to_i
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    root: pppw + sjmn
    dbpl: 5
    cczh: sllz + lgvd
    zczc: 2
    ptdq: humn - dvpt
    dvpt: 3
    lfqf: 4
    humn: 5
    ljgn: 2
    sjmn: drzm * dbpl
    sllz: 4
    pppw: cczh / lfqf
    lgvd: ljgn * ptdq
    drzm: hmdt - zczc
    hmdt: 32
  INPUT

  def test_solve_example
    assert_equal 152, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 63_119_856_257_960, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 301, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 3_006_709_232_464, solve2(read_file('input.txt'))
  end
end
