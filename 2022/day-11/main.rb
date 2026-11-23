# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

class Monkey
  attr_reader :inspected, :divisible_by

  def initialize(items, operation, by, divisible_by, to_throw)
    @items = items
    @operation = operation
    @by = by
    @divisible_by = divisible_by
    @to_throw = to_throw
    @inspected = 0
  end

  def items?
    @items.any?
  end

  # Returns [new worry level, monkey to throw to].
  def inspect_item(reducer: 1, modulo: nil)
    @inspected += 1
    item = operate(@items.shift) / reducer
    item %= modulo if modulo
    [item, (item % @divisible_by).zero? ? @to_throw[0] : @to_throw[1]]
  end

  def take(item)
    @items.push(item)
  end

  private

  def operate(item)
    by = @by == 'old' ? item : @by.to_i
    @operation == '+' ? item + by : item * by
  end
end

def parse_input(input)
  input.split("\n\n").map do |block|
    items = block[/Starting items: (.*)/, 1].split(', ').map(&:to_i)
    operation, by = block.match(/new = old (.) (\S+)/).captures
    divisible_by = block[/divisible by (\d+)/, 1].to_i
    if_true = block[/If true: throw to monkey (\d+)/, 1].to_i
    if_false = block[/If false: throw to monkey (\d+)/, 1].to_i
    Monkey.new(items, operation, by, divisible_by, [if_true, if_false])
  end
end

def monkey_business(monkeys, rounds, **)
  rounds.times do
    monkeys.each do |monkey|
      while monkey.items?
        item, throw_to = monkey.inspect_item(**)
        monkeys[throw_to].take(item)
      end
    end
  end
  monkeys.map(&:inspected).max(2).reduce(:*)
end

def solve(input)
  monkey_business(parse_input(input), 20, reducer: 3)
end

def solve2(input)
  monkeys = parse_input(input)
  # Worry levels only matter modulo the product of all divisors.
  monkey_business(monkeys, 10_000, modulo: monkeys.map(&:divisible_by).reduce(:*))
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    Monkey 0:
      Starting items: 79, 98
      Operation: new = old * 19
      Test: divisible by 23
        If true: throw to monkey 2
        If false: throw to monkey 3

    Monkey 1:
      Starting items: 54, 65, 75, 74
      Operation: new = old + 6
      Test: divisible by 19
        If true: throw to monkey 2
        If false: throw to monkey 0

    Monkey 2:
      Starting items: 79, 60, 97
      Operation: new = old * old
      Test: divisible by 13
        If true: throw to monkey 1
        If false: throw to monkey 3

    Monkey 3:
      Starting items: 74
      Operation: new = old + 3
      Test: divisible by 17
        If true: throw to monkey 0
        If false: throw to monkey 1
  INPUT

  def test_solve_example
    assert_equal 10_605, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 55_930, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 2_713_310_158, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 14_636_993_466, solve2(read_file('input.txt'))
  end
end
