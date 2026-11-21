# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def parse(input)
  workflows_block, parts_block = input.split("\n\n")
  workflows = workflows_block.lines.to_h do |line|
    name, body = line.strip.match(/(\w+)\{(.*)\}/).captures
    rules = body.split(',').map do |rule|
      if (m = rule.match(/([xmas])([<>])(\d+):(\w+)/))
        [m[1], m[2], m[3].to_i, m[4]]
      else
        [nil, nil, nil, rule]
      end
    end
    [name, rules]
  end
  parts = parts_block.lines.map { |line| line.scan(/([xmas])=(\d+)/).to_h { |k, v| [k, v.to_i] } }
  [workflows, parts]
end

def accepted?(workflows, part)
  name = 'in'
  until %w[A R].include?(name)
    name = workflows[name].find do |cat, op, value, _|
      cat.nil? || (op == '<' ? part[cat] < value : part[cat] > value)
    end.last
  end
  name == 'A'
end

def solve(input)
  workflows, parts = parse(input)
  parts.select { accepted?(workflows, it) }.sum { it.values.sum }
end

# Counts accepted combinations, splitting the inclusive ranges at each rule.
def count_accepted(workflows, name, ranges)
  return 0 if name == 'R'
  return ranges.values.reduce(1) { |acc, (lo, hi)| acc * (hi - lo + 1) } if name == 'A'

  total = 0
  workflows[name].each do |cat, op, value, target|
    unless cat
      total += count_accepted(workflows, target, ranges)
      break
    end

    lo, hi = ranges[cat]
    pass, fail = op == '<' ? [[lo, value - 1], [value, hi]] : [[value + 1, hi], [lo, value]]
    total += count_accepted(workflows, target, ranges.merge(cat => pass)) if pass[0] <= pass[1]
    break if fail[0] > fail[1]

    ranges = ranges.merge(cat => fail)
  end
  total
end

def solve2(input)
  workflows, = parse(input)
  count_accepted(workflows, 'in', %w[x m a s].to_h { [it, [1, 4000]] })
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    px{a<2006:qkq,m>2090:A,rfg}
    pv{a>1716:R,A}
    lnx{m>1548:A,A}
    rfg{s<537:gd,x>2440:R,A}
    qs{s>3448:A,lnx}
    qkq{x<1416:A,crn}
    crn{x>2662:A,R}
    in{s<1351:px,qqz}
    qqz{s>2770:qs,m<1801:hdj,R}
    gd{a>3333:R,R}
    hdj{m>838:A,pv}

    {x=787,m=2655,a=1222,s=2876}
    {x=1679,m=44,a=2067,s=496}
    {x=2036,m=264,a=79,s=2244}
    {x=2461,m=1339,a=466,s=291}
    {x=2127,m=1623,a=2188,s=1013}
  INPUT

  def test_solve_example
    assert_equal 19_114, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 446_935, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 167_409_079_868_000, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 141_882_534_122_898, solve2(read_file('input.txt'))
  end
end
