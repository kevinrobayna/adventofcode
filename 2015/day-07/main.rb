# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

MASK16 = 0xFFFF

def parse_circuit(input)
  input.lines.to_h do |line|
    expr, wire = line.strip.split(' -> ')
    [wire, expr.split]
  end
end

def evaluate(circuit, wire, cache = {})
  return wire.to_i if wire.match?(/\A\d+\z/)
  return cache[wire] if cache.key?(wire)

  value = ->(name) { evaluate(circuit, name, cache) }
  tokens = circuit.fetch(wire)
  cache[wire] =
    case tokens
    in [a] then value[a]
    in ['NOT', a] then ~value[a] & MASK16
    in [a, 'AND', b] then value[a] & value[b]
    in [a, 'OR', b] then value[a] | value[b]
    in [a, 'LSHIFT', b] then (value[a] << value[b]) & MASK16
    in [a, 'RSHIFT', b] then value[a] >> value[b]
    end
end

def solve(input, wire: 'a')
  evaluate(parse_circuit(input), wire)
end

def solve2(input)
  circuit = parse_circuit(input)
  circuit['b'] = [evaluate(circuit, 'a').to_s]
  evaluate(circuit, 'a')
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    123 -> x
    456 -> y
    x AND y -> d
    x OR y -> e
    x LSHIFT 2 -> f
    y RSHIFT 2 -> g
    NOT x -> h
    NOT y -> i
  INPUT

  def test_solve_example
    expected = { 'd' => 72, 'e' => 507, 'f' => 492, 'g' => 114, 'h' => 65_412, 'i' => 65_079, 'x' => 123, 'y' => 456 }
    expected.each { |wire, value| assert_equal value, solve(EXAMPLE, wire: wire) }
  end

  def test_solve_input
    assert_equal 16_076, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 2797, solve2(read_file('input.txt'))
  end
end
