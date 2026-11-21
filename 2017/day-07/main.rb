# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

Tower = Struct.new(:weights, :children) do
  def root
    (weights.keys - children.values.flatten).first
  end

  def total(name)
    @totals ||= {}
    @totals[name] ||= weights[name] + children[name].sum { |c| total(c) }
  end

  # Weight the single wrong program must have for the tower to balance.
  def corrected_weight(name = root)
    kids = children[name]
    groups = kids.group_by { |c| total(c) }
    return nil if groups.size <= 1

    odd = groups.values.find { |g| g.size == 1 }.first
    deeper = corrected_weight(odd)
    return deeper if deeper

    target = groups.keys.find { |t| t != total(odd) }
    weights[odd] + target - total(odd)
  end
end

def parse_tower(input)
  weights = {}
  children = {}
  input.each_line do |line|
    next unless line =~ /(\w+) \((\d+)\)(?: -> (.*))?/

    weights[Regexp.last_match(1)] = Regexp.last_match(2).to_i
    children[Regexp.last_match(1)] = Regexp.last_match(3).to_s.split(', ')
  end
  Tower.new(weights, children)
end

def solve(input)
  parse_tower(input).root
end

def solve2(input)
  parse_tower(input).corrected_weight
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    pbga (66)
    xhth (57)
    ebii (61)
    havc (66)
    ktlj (57)
    fwft (72) -> ktlj, cntj, xhth
    qoyq (66)
    padx (45) -> pbga, havc, qoyq
    tknk (41) -> ugml, padx, fwft
    jptl (61)
    ugml (68) -> gyxo, ebii, jptl
    gyxo (61)
    cntj (57)
  INPUT

  def test_solve_example
    assert_equal 'tknk', solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 'vvsvez', solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 60, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 362, solve2(read_file('input.txt'))
  end
end
