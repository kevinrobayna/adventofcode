# frozen_string_literal: true

require_relative '../../lib/aoc'

# Splits the worksheet into problems: [operator, number rows sliced to the problem's columns].
def problems(input)
  lines = input.lines.map(&:chomp).reject { |l| l.strip.empty? }
  width = lines.map(&:size).max
  lines = lines.map { |l| l.ljust(width) }
  *rows, ops = lines
  blank = (0...width).select { |c| lines.all? { |l| l[c] == ' ' } }
  bounds = ([-1] + blank + [width]).each_cons(2).map { |a, b| (a + 1)...b }.select { |r| r.begin < r.end }
  bounds.map { |cols| [ops[cols].strip, rows.map { |row| row[cols] }] }
end

def apply(op, numbers)
  op == '*' ? numbers.reduce(:*) : numbers.sum
end

def solve(input)
  problems(input).sum { |op, rows| apply(op, rows.map(&:to_i)) }
end

def solve2(input)
  problems(input).sum do |op, rows|
    columns = rows.map(&:chars).transpose.map { |col| col.join.strip }.reject(&:empty?)
    apply(op, columns.map(&:to_i))
  end
end

class AoCTest < Minitest::Test
  EXAMPLE = [
    '123 328  51 64 ',
    ' 45 64  387 23 ',
    '  6 98  215 314',
    '*   +   *   +  '
  ].join("\n")

  def test_solve_example
    assert_equal 4_277_556, solve(EXAMPLE)
  end

  def test_solve2_example
    assert_equal 3_263_827, solve2(EXAMPLE)
  end

  def test_trailing_spaces_trimmed
    assert_equal 3_263_827, solve2(EXAMPLE.lines.map(&:rstrip).join("\n"))
  end
end
