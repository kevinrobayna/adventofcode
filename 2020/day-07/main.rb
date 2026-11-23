# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def parse(input)
  input.lines.to_h do |line|
    outer, inner = line.split(' bags contain ')
    [outer, inner.scan(/(\d+) (\w+ \w+) bag/).to_h { |n, color| [color, n.to_i] }]
  end
end

def contains_gold?(rules, color, memo = {})
  memo.fetch(color) do
    memo[color] = rules[color].keys.any? { |c| c == 'shiny gold' || contains_gold?(rules, c, memo) }
  end
end

def bags_inside(rules, color)
  rules[color].sum { |c, n| n * (1 + bags_inside(rules, c)) }
end

def solve(input)
  rules = parse(input)
  memo = {}
  rules.keys.count { |color| contains_gold?(rules, color, memo) }
end

def solve2(input)
  bags_inside(parse(input), 'shiny gold')
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    light red bags contain 1 bright white bag, 2 muted yellow bags.
    dark orange bags contain 3 bright white bags, 4 muted yellow bags.
    bright white bags contain 1 shiny gold bag.
    muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
    shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
    dark olive bags contain 3 faded blue bags, 4 dotted black bags.
    vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
    faded blue bags contain no other bags.
    dotted black bags contain no other bags.
  INPUT

  EXAMPLE2 = <<~INPUT
    shiny gold bags contain 2 dark red bags.
    dark red bags contain 2 dark orange bags.
    dark orange bags contain 2 dark yellow bags.
    dark yellow bags contain 2 dark green bags.
    dark green bags contain 2 dark blue bags.
    dark blue bags contain 2 dark violet bags.
    dark violet bags contain no other bags.
  INPUT

  def test_solve_example
    assert_equal 4, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 296, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 32, solve2(EXAMPLE)
    assert_equal 126, solve2(EXAMPLE2)
  end

  def test_solve2_input
    assert_equal 9339, solve2(read_file('input.txt'))
  end
end
