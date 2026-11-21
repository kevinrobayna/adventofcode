# frozen_string_literal: true

require_relative '../../lib/aoc'

def parse(input)
  wires_text, gates_text = input.split("\n\n")
  wires = wires_text.lines.to_h do |line|
    name, value = line.split(': ')
    [name, value.to_i]
  end
  gates = gates_text.lines.to_h do |line|
    a, op, b, out = line.scan(/\w+/)
    [out, [a, op, b]]
  end
  [wires, gates]
end

def evaluate(wire, wires, gates)
  wires[wire] ||= begin
    a, op, b = gates.fetch(wire)
    va = evaluate(a, wires, gates)
    vb = evaluate(b, wires, gates)
    case op
    when 'AND' then va & vb
    when 'OR' then va | vb
    else va ^ vb
    end
  end
end

def solve(input)
  wires, gates = parse(input)
  gates.keys.select { _1.start_with?('z') }.sort.reverse.reduce(0) do |acc, z|
    (acc << 1) | evaluate(z, wires, gates)
  end
end

# The circuit is meant to be a ripple-carry adder. Outputs breaking its structural rules are
# the swapped wires:
# - every z wire except the final carry comes from an XOR;
# - an XOR not fed by x/y inputs must drive a z wire;
# - an XOR of x/y inputs (beyond bit 0) must feed another XOR;
# - an AND (beyond bit 0) must feed an OR.
def solve2(input)
  _, gates = parse(input)
  last_z = gates.keys.select { _1.start_with?('z') }.max
  consumers = Hash.new { |h, k| h[k] = [] }
  gates.each_value { |a, op, b| [a, b].each { consumers[_1] << op } }
  input_gate = ->(a, b) { [a, b].all? { _1.match?(/\A[xy]/) } }
  first_bit = ->(a, b) { [a, b].sort == %w[x00 y00] }

  wrong = gates.select do |out, (a, op, b)|
    if out.start_with?('z') && out != last_z
      op != 'XOR'
    elsif op == 'XOR' && !input_gate.call(a, b)
      true
    elsif op == 'XOR' && !first_bit.call(a, b)
      !consumers[out].include?('XOR')
    elsif op == 'AND' && !first_bit.call(a, b)
      !consumers[out].include?('OR')
    else
      false
    end
  end
  wrong.keys.sort.join(',')
end

# Builds a correct ripple-carry adder for `bits`-bit inputs, as puzzle text.
def build_adder(bits)
  gates = ['x00 XOR y00 -> z00', 'x00 AND y00 -> c00']
  (1...bits).each do |i|
    n = format('%02d', i)
    prev = format('c%02d', i - 1)
    carry = i == bits - 1 ? format('z%02d', bits) : "c#{n}"
    gates += ["x#{n} XOR y#{n} -> s#{n}", "x#{n} AND y#{n} -> a#{n}", "s#{n} XOR #{prev} -> z#{n}",
              "s#{n} AND #{prev} -> t#{n}", "a#{n} OR t#{n} -> #{carry}"]
  end
  wires = bits.times.flat_map { |i| [format('x%02d: 0', i), format('y%02d: 0', i)] }
  "#{wires.join("\n")}\n\n#{gates.join("\n")}\n"
end

def swap_outputs(text, a, b)
  text.gsub(/-> (#{a}|#{b})$/) { "-> #{::Regexp.last_match(1) == a ? b : a}" }
end

class AoCTest < Minitest::Test
  SMALL = <<~INPUT
    x00: 1
    x01: 1
    x02: 1
    y00: 0
    y01: 1
    y02: 0

    x00 AND y00 -> z00
    x01 XOR y01 -> z01
    x02 OR y02 -> z02
  INPUT

  EXAMPLE = <<~INPUT
    x00: 1
    x01: 0
    x02: 1
    x03: 1
    x04: 0
    y00: 1
    y01: 1
    y02: 1
    y03: 1
    y04: 1

    ntg XOR fgs -> mjb
    y02 OR x01 -> tnw
    kwq OR kpj -> z05
    x00 OR x03 -> fst
    tgd XOR rvg -> z01
    vdt OR tnw -> bfw
    bfw AND frj -> z10
    ffh OR nrd -> bqk
    y00 AND y03 -> djm
    y03 OR y00 -> psh
    bqk OR frj -> z08
    tnw OR fst -> frj
    gnj AND tgd -> z11
    bfw XOR mjb -> z00
    x03 OR x00 -> vdt
    gnj AND wpb -> z02
    x04 AND y00 -> kjc
    djm OR pbm -> qhw
    nrd AND vdt -> hwm
    kjc AND fst -> rvg
    y04 OR y02 -> fgs
    y01 AND x02 -> pbm
    ntg OR kjc -> kwq
    psh XOR fgs -> tgd
    qhw XOR tgd -> z09
    pbm OR djm -> kpj
    x03 XOR y03 -> ffh
    x00 XOR y04 -> ntg
    bfw OR bqk -> z06
    nrd XOR fgs -> wpb
    frj XOR qhw -> z04
    bqk OR frj -> z07
    y03 OR x01 -> nrd
    hwm AND bqk -> z03
    tgd XOR rvg -> z12
    tnw OR pbm -> gnj
  INPUT

  def test_solve_example
    assert_equal 4, solve(SMALL)
    assert_equal 2024, solve(EXAMPLE)
  end

  def test_adder_builder_adds
    circuit = build_adder(8).sub('x03: 0', 'x03: 1').sub('y07: 0', 'y07: 1').sub('y02: 0', 'y02: 1')
    assert_equal 0b10001100, solve(circuit)
  end

  def test_solve2_correct_adder_has_no_swaps
    assert_equal '', solve2(build_adder(45))
  end

  def test_solve2_swapped_adder
    circuit = build_adder(45)
    [%w[z07 t07], %w[s15 a15], %w[z23 c23], %w[z31 a31]].each { |a, b| circuit = swap_outputs(circuit, a, b) }
    assert_equal 'a15,a31,c23,s15,t07,z07,z23,z31', solve2(circuit)
  end

  def test_solve_input
    assert_equal 69_201_640_933_606, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 'dhq,hbs,jcp,kfp,pdg,z18,z22,z27', solve2(read_file('input.txt'))
  end
end
