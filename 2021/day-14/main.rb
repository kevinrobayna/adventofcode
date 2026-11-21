# frozen_string_literal: true

require_relative '../../lib/aoc'

def polymerize(input, steps)
  template, rules_part = input.split("\n\n")
  rules = rules_part.scan(/(\w\w) -> (\w)/).to_h
  pairs = template.chars.each_cons(2).map(&:join).tally
  steps.times do
    next_pairs = Hash.new(0)
    pairs.each do |pair, count|
      insert = rules[pair]
      if insert
        next_pairs[pair[0] + insert] += count
        next_pairs[insert + pair[1]] += count
      else
        next_pairs[pair] += count
      end
    end
    pairs = next_pairs
  end
  counts = Hash.new(0)
  pairs.each { |pair, count| counts[pair[0]] += count }
  counts[template[-1]] += 1
  counts.values.max - counts.values.min
end

def solve(input)
  polymerize(input, 10)
end

def solve2(input)
  polymerize(input, 40)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    NNCB

    CH -> B
    HH -> N
    CB -> H
    NH -> C
    HB -> C
    HC -> B
    HN -> C
    NN -> C
    BH -> H
    NC -> B
    NB -> B
    BN -> B
    BB -> N
    BC -> B
    CC -> N
    CN -> C
  INPUT

  def test_solve_example
    assert_equal 1588, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 2797, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 2_188_189_693_529, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 2_926_813_379_532, solve2(read_file('input.txt'))
  end
end
