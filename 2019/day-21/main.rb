# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end
require_relative '../intcode'

# Jump when a hole is within the next three tiles and the landing tile D is ground.
WALK = ['NOT A J', 'NOT B T', 'OR T J', 'NOT C T', 'OR T J', 'AND D J', 'WALK'].freeze
# Same, but only when after landing we can either step (E) or jump again (H).
RUN = [*WALK[0..-2], 'NOT E T', 'NOT T T', 'OR H T', 'AND T J', 'RUN'].freeze

def hull_damage(input, script)
  out = Intcode.new(input).run_ascii(*script)
  raise "droid fell:\n#{out.pack('c*')}" if out.last < 128

  out.last
end

def solve(input)
  hull_damage(input, WALK)
end

def solve2(input)
  hull_damage(input, RUN)
end

# Simulates a springscript on a hull (true = ground) to check the jump logic offline.
def survives?(script, hull, reach)
  pos = 0
  while pos < hull.size - 1
    sensors = ('A'..'I').first(reach).to_h { |s| [s, hull.fetch(pos + s.ord - 64, true)] }
    reg = { 'T' => false, 'J' => false }
    script[0..-2].each do |line|
      op, x, y = line.split
      v = sensors.fetch(x) { reg[x] }
      reg[y] = { 'AND' => v && reg[y], 'OR' => v || reg[y], 'NOT' => !v }[op]
    end
    pos += reg['J'] ? 4 : 1
    return false unless hull.fetch(pos, true)
  end
  true
end

class AoCTest < Minitest::Test
  def hull(text) = text.chars.map { it == '#' }

  def test_solve_example
    assert survives?(WALK, hull('#####.###########'), 4)
    assert survives?(WALK, hull('#####...#########'), 4)
    assert survives?(WALK, hull('#####..#.########'), 4)
  end

  def test_solve_input
    assert_equal 19_357_335, solve(read_file('input.txt'))
  end

  def test_solve2_example
    refute survives?(WALK, hull('#####.#.##..#.###'), 4)
    assert survives?(RUN, hull('#####.#.##..#.###'), 9)
    assert survives?(RUN, hull('#####.##.##.#.###'), 9)
    assert survives?(RUN, hull('#####...#...#.####'), 9)
  end

  def test_solve2_input
    assert_equal 1_140_147_758, solve2(read_file('input.txt'))
  end
end
