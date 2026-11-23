# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def solve(input)
  stacks, instructions = parse_input(input)
  instructions.each do |amount, from, to|
    stacks[to].unshift(*stacks[from].shift(amount).reverse)
  end
  stacks.map(&:first).join
end

def solve2(input)
  stacks, instructions = parse_input(input)
  instructions.each do |amount, from, to|
    stacks[to].unshift(*stacks[from].shift(amount))
  end
  stacks.map(&:first).join
end

# Stacks are arrays with the top crate first.
def parse_input(input)
  drawing, moves = input.split("\n\n")
  stacks = []
  drawing.lines.each do |line|
    next unless line.include?('[')

    line.chars.each_slice(4).with_index do |slot, inx|
      stacks[inx] ||= []
      stacks[inx] << slot[1] if slot[1]&.match?(/[A-Z]/)
    end
  end
  instructions = moves.lines.map do |line|
    amount, from, to = line.scan(/\d+/).map(&:to_i)
    [amount, from - 1, to - 1]
  end
  [stacks, instructions]
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
        [D]
    [N] [C]
    [Z] [M] [P]
     1   2   3

    move 1 from 2 to 1
    move 3 from 1 to 3
    move 2 from 2 to 1
    move 1 from 1 to 2
  INPUT

  def test_solve_example
    assert_equal 'CMZ', solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 'WCZTHTMPS', solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 'MCD', solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 'BLSGJSDTS', solve2(read_file('input.txt'))
  end
end
