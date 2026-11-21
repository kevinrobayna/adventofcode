# frozen_string_literal: true

require_relative '../../lib/aoc'

PAIRS = { '(' => ')', '[' => ']', '{' => '}', '<' => '>' }.freeze
ERROR_SCORE = { ')' => 3, ']' => 57, '}' => 1197, '>' => 25_137 }.freeze
COMPLETION_SCORE = { ')' => 1, ']' => 2, '}' => 3, '>' => 4 }.freeze

# Returns [:corrupted, char] or [:incomplete, expected_closings].
def check_line(line)
  expected = []
  line.each_char do |char|
    if PAIRS.key?(char)
      expected.push(PAIRS[char])
    elsif expected.pop != char
      return [:corrupted, char]
    end
  end
  [:incomplete, expected.reverse]
end

def solve(input)
  input.split("\n").sum do |line|
    status, char = check_line(line)
    status == :corrupted ? ERROR_SCORE[char] : 0
  end
end

def solve2(input)
  scores = input.split("\n").filter_map do |line|
    status, closings = check_line(line)
    next unless status == :incomplete

    closings.reduce(0) { |score, char| (score * 5) + COMPLETION_SCORE[char] }
  end
  scores.sort[scores.size / 2]
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    [({(<(())[]>[[{[]{<()<>>
    [(()[<>])]({[<{<<[]>>(
    {([(<{}[<>[]}>{[]{[(<()>
    (((({<>}<{<{<>}{[]{[]{}
    [[<[([]))<([[{}[[()]]]
    [{[{({}]{}}([{[{{{}}([]
    {<[[]]>}<{[{[{[]{()[[[]
    [<(<(<(<{}))><([]([]()
    <{([([[(<>()){}]>(<<{{
    <{([{{}}[<[[[<>{}]]]>[]]
  INPUT

  def test_solve_example
    assert_equal 26_397, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 390_993, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 288_957, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 2_391_385_187, solve2(read_file('input.txt'))
  end
end
