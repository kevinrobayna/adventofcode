# frozen_string_literal: true

require_relative '../../lib/aoc'

# One machine: target light pattern, buttons and joltage targets. Counter vectors are packed into a single
# Integer, FIELD bits per counter, so vector add/subtract/halve/parity are plain integer operations.
class Machine
  FIELD = 16

  def initialize(line)
    lights = line[/\[(.*)\]/, 1].chars.map { |ch| ch == '#' ? 1 : 0 }
    @lights = pack(lights)
    @buttons = line.scan(/\(([\d,]*)\)/).map { |(b)| b.split(',').sum { |c| 1 << (FIELD * c.to_i) } }
    @joltage = pack(line[/\{(.*)\}/, 1].split(',').map(&:to_i))
    @low = pack(Array.new(lights.size, 1))
    @guard = @low << (FIELD - 1)
  end

  def fewest_light_presses
    subsets_by_parity.fetch(@lights).map(&:last).min
  end

  # Any solution splits into the odd-pressed buttons (a subset matching the parity of the target) plus
  # twice a solution for the halved remainder, so recurse on that.
  def fewest_joltage_presses(target = @joltage, memo = {})
    return 0 if target.zero?
    return memo[target] if memo.key?(target)

    memo[target] = subsets_by_parity.fetch(target & @low, []).filter_map do |effect, presses|
      rest = (target | @guard) - effect
      next unless rest & @guard == @guard

      sub = fewest_joltage_presses((rest ^ @guard) >> 1, memo)
      presses + (2 * sub) if sub
    end.min
  end

  private

  def pack(values)
    values.each_with_index.sum { |v, i| v << (FIELD * i) }
  end

  # Every subset of buttons pressed once, grouped by the parity pattern it leaves: {parity => [[effect, presses]]}.
  def subsets_by_parity
    @subsets_by_parity ||= begin
      subsets = [[0, 0]]
      (1...(1 << @buttons.size)).each do |mask|
        low = mask.bit_length - 1
        effect, presses = subsets[mask ^ (1 << low)]
        subsets << [effect + @buttons[low], presses + 1]
      end
      subsets.group_by { |effect, _| effect & @low }
    end
  end
end

def machines(input)
  input.lines.reject { |l| l.strip.empty? }.map { |line| Machine.new(line) }
end

def solve(input)
  machines(input).sum(&:fewest_light_presses)
end

def solve2(input)
  machines(input).sum(&:fewest_joltage_presses)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
    [...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
    [.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
  INPUT

  def test_solve_example
    assert_equal 7, solve(EXAMPLE)
  end

  def test_solve2_example
    assert_equal 33, solve2(EXAMPLE)
  end

  def test_solve2_per_machine
    assert_equal [10, 12, 11], machines(EXAMPLE).map(&:fewest_joltage_presses)
  end

  def test_solve_input
    assert_equal 578, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 20_709, solve2(read_file('input.txt'))
  end
end
