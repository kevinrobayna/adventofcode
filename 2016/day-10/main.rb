# frozen_string_literal: true

require_relative '../../lib/aoc'

# Runs the bot factory; returns [comparisons (bot => sorted pair), outputs (id => value)].
def run_bots(input)
  holding = Hash.new { |h, k| h[k] = [] }
  rules = {}
  input.each_line do |line|
    case line
    when /value (\d+) goes to bot (\d+)/
      holding["bot #{::Regexp.last_match(2)}"] << ::Regexp.last_match(1).to_i
    when /(bot \d+) gives low to (\w+ \d+) and high to (\w+ \d+)/
      rules[::Regexp.last_match(1)] = [::Regexp.last_match(2), ::Regexp.last_match(3)]
    end
  end

  comparisons = {}
  while (bot, chips = holding.find { |k, v| k.start_with?('bot') && v.size == 2 })
    low, high = chips.sort
    comparisons[bot] = [low, high]
    holding[bot] = []
    holding[rules[bot][0]] << low
    holding[rules[bot][1]] << high
  end
  outputs = holding.select { |k, _| k.start_with?('output') }.transform_keys { |k| k.split.last.to_i }.transform_values(&:first)
  [comparisons, outputs]
end

def solve(input, chips: [17, 61])
  run_bots(input).first.key(chips).split.last.to_i
end

def solve2(input)
  outputs = run_bots(input).last
  outputs[0] * outputs[1] * outputs[2]
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    value 5 goes to bot 2
    bot 2 gives low to bot 1 and high to bot 0
    value 3 goes to bot 1
    bot 1 gives low to output 1 and high to bot 0
    bot 0 gives low to output 2 and high to output 0
    value 2 goes to bot 2
  INPUT

  def test_solve_example
    assert_equal 2, solve(EXAMPLE, chips: [2, 5])
  end

  def test_solve_input
    assert_equal 181, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 30, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 12_567, solve2(read_file('input.txt'))
  end
end
