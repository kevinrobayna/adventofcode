# frozen_string_literal: true

require_relative '../../lib/aoc'

def program(input)
  mask = nil
  input.lines.each do |line|
    if line.start_with?('mask')
      mask = line.split(' = ').last.strip
    else
      address, value = line.scan(/\d+/).map(&:to_i)
      yield mask, address, value
    end
  end
end

def solve(input)
  memory = {}
  program(input) do |mask, address, value|
    memory[address] = (value | mask.tr('X', '0').to_i(2)) & mask.tr('X', '1').to_i(2)
  end
  memory.values.sum
end

def addresses(mask, address)
  floating = mask.chars.reverse.each_index.select { |i| mask[-1 - i] == 'X' }
  base = (address | mask.tr('X', '0').to_i(2)) & ~floating.sum { |i| 1 << i }
  (0..floating.size).flat_map { |n| floating.combination(n).map { |bits| base | bits.sum { |i| 1 << i } } }
end

def solve2(input)
  memory = {}
  program(input) do |mask, address, value|
    addresses(mask, address).each { |a| memory[a] = value }
  end
  memory.values.sum
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
    mem[8] = 11
    mem[7] = 101
    mem[8] = 0
  INPUT

  EXAMPLE2 = <<~INPUT
    mask = 000000000000000000000000000000X1001X
    mem[42] = 100
    mask = 00000000000000000000000000000000X0XX
    mem[26] = 1
  INPUT

  def test_solve_example
    assert_equal 165, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 12_512_013_221_615, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 208, solve2(EXAMPLE2)
  end

  def test_solve2_input
    assert_equal 3_905_642_473_893, solve2(read_file('input.txt'))
  end
end
