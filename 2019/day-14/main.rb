# frozen_string_literal: true

require_relative '../../lib/aoc'

def reactions(input)
  input.lines.to_h do |line|
    *ins, out = line.scan(/(\d+) (\w+)/).map { |n, c| [c, n.to_i] }
    [out[0], [out[1], ins]]
  end
end

# Ore needed to produce `fuel` FUEL, processing chemicals in topological order.
def ore_for(recipes, fuel)
  order = []
  visit = lambda do |chem|
    next if chem == 'ORE' || order.include?(chem)

    recipes[chem][1].each { visit.call(it[0]) }
    order << chem
  end
  visit.call('FUEL')
  need = Hash.new(0)
  need['FUEL'] = fuel
  order.reverse_each do |chem|
    qty, ins = recipes[chem]
    times = (need[chem] + qty - 1) / qty
    ins.each { |c, n| need[c] += n * times }
  end
  need['ORE']
end

def solve(input)
  ore_for(reactions(input), 1)
end

def solve2(input, ore: 1_000_000_000_000)
  recipes = reactions(input)
  (1..ore).bsearch { ore_for(recipes, it) > ore } - 1
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    10 ORE => 10 A
    1 ORE => 1 B
    7 A, 1 B => 1 C
    7 A, 1 C => 1 D
    7 A, 1 D => 1 E
    7 A, 1 E => 1 FUEL
  INPUT

  EXAMPLE2 = <<~INPUT
    9 ORE => 2 A
    8 ORE => 3 B
    7 ORE => 5 C
    3 A, 4 B => 1 AB
    5 B, 7 C => 1 BC
    4 C, 1 A => 1 CA
    2 AB, 3 BC, 4 CA => 1 FUEL
  INPUT

  EXAMPLE3 = <<~INPUT
    157 ORE => 5 NZVS
    165 ORE => 6 DCFZ
    44 XJWVT, 5 KHKGT, 1 QDVJ, 29 NZVS, 9 GPVTF, 48 HKGWZ => 1 FUEL
    12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ
    179 ORE => 7 PSHF
    177 ORE => 5 HKGWZ
    7 DCFZ, 7 PSHF => 2 XJWVT
    165 ORE => 2 GPVTF
    3 DCFZ, 7 NZVS, 5 HKGWZ, 10 PSHF => 8 KHKGT
  INPUT

  EXAMPLE5 = <<~INPUT
    171 ORE => 8 CNZTR
    7 ZLQW, 3 BMBT, 9 XCVML, 26 XMNCP, 1 WPTQ, 2 MZWV, 1 RJRHP => 4 PLWSL
    114 ORE => 4 BHXH
    14 VRPVC => 6 BMBT
    6 BHXH, 18 KTJDG, 12 WPTQ, 7 PLWSL, 31 FHTLT, 37 ZDVW => 1 FUEL
    6 WPTQ, 2 BMBT, 8 ZLQW, 18 KTJDG, 1 XMNCP, 6 MZWV, 1 RJRHP => 6 FHTLT
    15 XDBXC, 2 LTCX, 1 VRPVC => 6 ZLQW
    13 WPTQ, 10 LTCX, 3 RJRHP, 14 XMNCP, 2 MZWV, 1 ZLQW => 1 ZDVW
    5 BMBT => 4 WPTQ
    189 ORE => 9 KTJDG
    1 MZWV, 17 XDBXC, 3 XCVML => 2 XMNCP
    12 VRPVC, 27 CNZTR => 2 XDBXC
    15 KTJDG, 12 BHXH => 5 XCVML
    3 BHXH, 2 VRPVC => 7 MZWV
    121 ORE => 7 VRPVC
    7 XCVML => 6 RJRHP
    5 BHXH, 4 VRPVC => 5 LTCX
  INPUT

  def test_solve_example
    assert_equal 31, solve(EXAMPLE)
    assert_equal 165, solve(EXAMPLE2)
    assert_equal 13_312, solve(EXAMPLE3)
    assert_equal 2_210_736, solve(EXAMPLE5)
  end

  def test_solve_input
    assert_equal 469_536, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 82_892_753, solve2(EXAMPLE3)
    assert_equal 460_664, solve2(EXAMPLE5)
  end

  def test_solve2_input
    assert_equal 3_343_477, solve2(read_file('input.txt'))
  end
end
