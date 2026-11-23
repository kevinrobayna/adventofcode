# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

# Recursive-descent evaluator; `precedence` maps operator => binding power.
class Evaluator
  def initialize(expr, precedence)
    @tokens = expr.scan(/\d+|[+*()]/)
    @precedence = precedence
  end

  def evaluate
    expression(0)
  end

  private

  def expression(min_power)
    left = primary
    while (op = @tokens.first) && @precedence.key?(op) && @precedence[op] >= min_power
      @tokens.shift
      right = expression(@precedence[op] + 1)
      left = op == '+' ? left + right : left * right
    end
    left
  end

  def primary
    token = @tokens.shift
    return token.to_i unless token == '('

    value = expression(0)
    @tokens.shift # ')'
    value
  end
end

def solve(input)
  input.lines.sum { |l| Evaluator.new(l, { '+' => 1, '*' => 1 }).evaluate }
end

def solve2(input)
  input.lines.sum { |l| Evaluator.new(l, { '+' => 2, '*' => 1 }).evaluate }
end

class AoCTest < Minitest::Test
  def test_solve_example
    assert_equal 71, solve('1 + 2 * 3 + 4 * 5 + 6')
    assert_equal 51, solve('1 + (2 * 3) + (4 * (5 + 6))')
    assert_equal 26, solve('2 * 3 + (4 * 5)')
    assert_equal 437, solve('5 + (8 * 3 + 9 + 3 * 4 * 3)')
    assert_equal 12_240, solve('5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))')
    assert_equal 13_632, solve('((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2')
  end

  def test_solve_input
    assert_equal 800_602_729_153, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 231, solve2('1 + 2 * 3 + 4 * 5 + 6')
    assert_equal 51, solve2('1 + (2 * 3) + (4 * (5 + 6))')
    assert_equal 46, solve2('2 * 3 + (4 * 5)')
    assert_equal 1445, solve2('5 + (8 * 3 + 9 + 3 * 4 * 3)')
    assert_equal 669_060, solve2('5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))')
    assert_equal 23_340, solve2('((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2')
  end

  def test_solve2_input
    assert_equal 92_173_009_047_076, solve2(read_file('input.txt'))
  end
end
