# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def parse(input)
  rules_part, mine, nearby = input.split("\n\n")
  rules = rules_part.lines.to_h do |line|
    name, ranges = line.split(': ')
    [name, ranges.scan(/(\d+)-(\d+)/).map { |a, b| a.to_i..b.to_i }]
  end
  ticket = ->(l) { l.split(',').map(&:to_i) }
  [rules, ticket.call(mine.lines[1]), nearby.lines.drop(1).map(&ticket)]
end

def valid_for?(ranges, value)
  ranges.any? { |r| r.cover?(value) }
end

def solve(input)
  rules, _, nearby = parse(input)
  nearby.flatten.reject { |v| rules.values.any? { |ranges| valid_for?(ranges, v) } }.sum
end

# Returns { field name => column index }.
def field_positions(input)
  rules, mine, nearby = parse(input)
  valid = nearby.select { |t| t.all? { |v| rules.values.any? { |ranges| valid_for?(ranges, v) } } }
  columns = (valid + [mine]).transpose
  candidates = rules.to_h do |name, ranges|
    [name, columns.each_index.select { |i| columns[i].all? { |v| valid_for?(ranges, v) } }]
  end
  positions = {}
  until candidates.empty?
    name, (index,) = candidates.find { |_, idx| idx.size == 1 }
    raise 'ambiguous field assignment' unless name

    positions[name] = index
    candidates.delete(name)
    candidates.each_value { |idx| idx.delete(index) }
  end
  positions
end

def solve2(input)
  mine = parse(input)[1]
  field_positions(input).select { |name, _| name.start_with?('departure') }.values.map { |i| mine[i] }.reduce(:*)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    class: 1-3 or 5-7
    row: 6-11 or 33-44
    seat: 13-40 or 45-50

    your ticket:
    7,1,14

    nearby tickets:
    7,3,47
    40,4,50
    55,2,20
    38,6,12
  INPUT

  EXAMPLE2 = <<~INPUT
    class: 0-1 or 4-19
    row: 0-5 or 8-19
    seat: 0-13 or 16-19

    your ticket:
    11,12,13

    nearby tickets:
    3,9,18
    15,1,5
    5,14,9
  INPUT

  def test_solve_example
    assert_equal 71, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 28_884, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal({ 'row' => 0, 'class' => 1, 'seat' => 2 }, field_positions(EXAMPLE2))
  end

  def test_solve2_input
    assert_equal 1_001_849_322_119, solve2(read_file('input.txt'))
  end
end
