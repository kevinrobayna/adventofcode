# frozen_string_literal: true

def compare_solutions(expected, actual)
  raise "Expected #{expected} but got #{actual}" unless expected == actual
end

def read_file(*args)
  File.read(File.join(File.absolute_path('.'), *args))
end

def parse_input(filename)
  monkeys = []
  items = []
  operation = nil
  by = nil
  divisible_by = nil
  if_true = nil
  read_file(filename).each_line do |line|
    line.strip.match(/Starting items: (.*)/) do |match|
      items = match[1].split(',').map(&:strip).map(&:to_i)
    end

    line.strip.match(/Operation: new = old (.) (.*)/) do |match|
      operation = match[1]
      by = match[2]
    end

    line.strip.match(/Test: divisible by (\d+)/) do |match|
      divisible_by = match[1].to_i
    end

    line.strip.match(/If true: throw to monkey (\d+)/) do |match|
      if_true = match[1].to_i
    end

    line.strip.match(/If false: throw to monkey (\d+)/) do |match|
      if_false = match[1].to_i

      monkeys << Monkey.new(items, operation, by, divisible_by, [if_true, if_false])
    end
  end

  monkeys
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
    @items.size.positive?
  end

  def inspect_item(reducer = 1)
    @inspected += 1
    item = (operate(@items.shift) / reducer).floor
    throw_to = test(item)
    [item, throw_to]
  end

  def take(item)
    @items.push(item)
  end

  private

  def test(item)
    if (item % @divisible_by).zero?
      @to_throw[0]
    else
      @to_throw[1]
    end
  end

  def operate(item)
    by = if @by == 'old'
           item
         else
           @by.to_i
         end
    case @operation
    when '+'
      item + by
    when '*'
      item * by
    when 'old'
      item * item
    else
      raise "Unknown operation: #{@operation}"
    end
  end

  def to_s
    "Monkey:
  Starting items: #{@items.join(', ')}
  Operation: new = old #{@operation} #{@by}
  Test: divisible by #{@divisible_by}
    If true: throw to monkey #{@to_throw[0]}
    If false: throw to monkey #{@to_throw[1]}\n"
  end
end

def solve(filename)
  monkeys = parse_input(filename)

  20.times do |_round|
    monkeys.each do |monkey|
      while monkey.items?
        item, throw_to = monkey.inspect_item(3)
        monkeys[throw_to].take(item)
      end
    end
  end

  inspected_items = monkeys.map(&:inspected).sort.reverse
  inspected_items[0] * inspected_items[1]
end

def solve2(filename)
  monkeys = parse_input(filename)

  # https://en.wikipedia.org/wiki/Chinese_remainder_theorem
  divider = monkeys.map(&:divisible_by).reduce(1.0) { |a, b| Float(a * b) }.floor

  10_000.times do |_round|
    monkeys.each do |monkey|
      while monkey.items?
        item, throw_to = monkey.inspect_item
        item = item % divider
        monkeys[throw_to].take(item)
      end
    end
  end

  inspected_items = monkeys.map(&:inspected).sort.reverse
  inspected_items[0] * inspected_items[1]
end

compare_solutions(10_605, solve('2022/day-11/test.txt'))
puts 'Part1', solve('2022/day-11/input.txt')

compare_solutions(2_713_310_158, solve2('2022/day-11/test.txt'))
puts 'Part2', solve2('2022/day-11/input.txt')
