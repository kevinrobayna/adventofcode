# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def parse(input)
  rules_text, updates_text = input.split("\n\n")
  rules = rules_text.lines.to_set { _1.strip.split('|').map(&:to_i) }
  updates = updates_text.lines.map { _1.strip.split(',').map(&:to_i) }
  [rules, updates]
end

# Every pair of pages in an update has a rule, so the rules give a total order.
def ordered(update, rules)
  update.sort { |a, b| rules.include?([b, a]) ? 1 : -1 }
end

def solve(input)
  rules, updates = parse(input)
  updates.select { ordered(_1, rules) == _1 }.sum { _1[_1.size / 2] }
end

def solve2(input)
  rules, updates = parse(input)
  updates.filter_map do |update|
    sorted = ordered(update, rules)
    sorted[sorted.size / 2] unless sorted == update
  end.sum
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    47|53
    97|13
    97|61
    97|47
    75|29
    61|13
    75|53
    29|13
    97|29
    53|29
    61|53
    97|53
    61|29
    47|13
    75|47
    97|75
    47|61
    75|61
    47|29
    75|13
    53|13

    75,47,61,53,29
    97,61,53,29,13
    75,29,13
    75,97,47,61,53
    61,13,29
    97,13,75,29,47
  INPUT

  def test_solve_example
    assert_equal 143, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 6260, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 123, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 5346, solve2(read_file('input.txt'))
  end
end
