# frozen_string_literal: true

require_relative '../../lib/aoc'

def parse(input)
  input.split("\n").map do |line|
    patterns, output = line.split(' | ')
    [patterns.split.map { |p| p.chars.sort.join }, output.split.map { |p| p.chars.sort.join }]
  end
end

def solve(input)
  parse(input).sum { |_, output| output.count { |o| [2, 3, 4, 7].include?(o.size) } }
end

# Deduces the digit for each (sorted) pattern by segment overlap with 1 and 4.
def decode(patterns)
  one = patterns.find { |p| p.size == 2 }.chars
  four = patterns.find { |p| p.size == 4 }.chars
  patterns.to_h do |p|
    chars = p.chars
    common1 = (chars & one).size
    common4 = (chars & four).size
    digit = case [chars.size, common1, common4]
            in [2, *] then 1
            in [3, *] then 7
            in [4, *] then 4
            in [7, *] then 8
            in [5, 2, _] then 3
            in [5, _, 3] then 5
            in [5, *] then 2
            in [6, 1, _] then 6
            in [6, _, 4] then 9
            in [6, *] then 0
            end
    [p, digit]
  end
end

def solve2(input)
  parse(input).sum do |patterns, output|
    mapping = decode(patterns)
    output.map { |o| mapping[o] }.join.to_i
  end
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
    edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
    fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
    fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
    aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
    fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
    dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
    bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
    egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
    gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
  INPUT

  def test_solve_example
    assert_equal 26, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 318, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 61_229, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 996_280, solve2(read_file('input.txt'))
  end
end
