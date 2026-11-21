# frozen_string_literal: true

require_relative '../../lib/aoc'

def parse(input)
  rules_part, messages = input.split("\n\n")
  rules = rules_part.lines.to_h do |line|
    id, body = line.split(': ')
    rule = body.include?('"') ? body[/"(\w)"/, 1] : body.split('|').map { |alt| alt.split.map(&:to_i) }
    [id.to_i, rule]
  end
  [rules, messages.split]
end

# Returns every position where a match of `rule` starting at `pos` can end.
def match_ends(rules, rule, message, pos)
  body = rules[rule]
  if body.is_a?(String)
    return message[pos] == body ? [pos + 1] : []
  end

  body.flat_map do |seq|
    seq.reduce([pos]) do |positions, sub|
      positions.flat_map { |p| p < message.size ? match_ends(rules, sub, message, p) : [] }
    end
  end.uniq
end

def count_matches(rules, messages)
  messages.count { |m| match_ends(rules, 0, m, 0).include?(m.size) }
end

def solve(input)
  count_matches(*parse(input))
end

def solve2(input)
  rules, messages = parse(input)
  rules[8] = [[42], [42, 8]]
  rules[11] = [[42, 31], [42, 11, 31]]
  count_matches(rules, messages)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    0: 4 1 5
    1: 2 3 | 3 2
    2: 4 4 | 5 5
    3: 4 5 | 5 4
    4: "a"
    5: "b"

    ababbb
    bababa
    abbbab
    aaabbb
    aaaabbb
  INPUT

  EXAMPLE2 = <<~INPUT
    42: 9 14 | 10 1
    9: 14 27 | 1 26
    10: 23 14 | 28 1
    1: "a"
    11: 42 31
    5: 1 14 | 15 1
    19: 14 1 | 14 14
    12: 24 14 | 19 1
    16: 15 1 | 14 14
    31: 14 17 | 1 13
    6: 14 14 | 1 14
    2: 1 24 | 14 4
    0: 8 11
    13: 14 3 | 1 12
    15: 1 | 14
    17: 14 2 | 1 7
    23: 25 1 | 22 14
    28: 16 1
    4: 1 1
    20: 14 14 | 1 15
    3: 5 14 | 16 1
    27: 1 6 | 14 18
    14: "b"
    21: 14 1 | 1 14
    25: 1 1 | 1 14
    22: 14 14
    8: 42
    26: 14 22 | 1 20
    18: 15 15
    7: 14 5 | 1 21
    24: 14 1

    abbbbbabbbaaaababbaabbbbabababbbabbbbbbabaaaa
    bbabbbbaabaabba
    babbbbaabbbbbabbbbbbaabaaabaaa
    aaabbbbbbaaaabaababaabababbabaaabbababababaaa
    bbbbbbbaaaabbbbaaabbabaaa
    bbbababbbbaaaaaaaabbababaaababaabab
    ababaaaaaabaaab
    ababaaaaabbbaba
    baabbaaaabbaaaababbaababb
    abbbbabbbbaaaababbbbbbaaaababb
    aaaaabbaabaaaaababaa
    aaaabbaaaabbaaa
    aaaabbaabbaaaaaaabbbabbbaaabbaabaaa
    babaaabbbaaabaababbaabababaaab
    aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba
  INPUT

  def test_solve_example
    assert_equal 2, solve(EXAMPLE)
    assert_equal 3, solve(EXAMPLE2)
  end

  def test_solve_input
    assert_equal 160, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 12, solve2(EXAMPLE2)
  end

  def test_solve2_input
    assert_equal 357, solve2(read_file('input.txt'))
  end
end
