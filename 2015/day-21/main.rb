# frozen_string_literal: true

require_relative '../../lib/aoc'

Item = Struct.new(:cost, :damage, :armor)

WEAPONS = [[8, 4, 0], [10, 5, 0], [25, 6, 0], [40, 7, 0], [74, 8, 0]].map { |i| Item.new(*i) }.freeze
ARMORS = [[0, 0, 0], [13, 0, 1], [31, 0, 2], [53, 0, 3], [75, 0, 4], [102, 0, 5]].map { |i| Item.new(*i) }.freeze
RINGS = [[25, 1, 0], [50, 2, 0], [100, 3, 0], [20, 0, 1], [40, 0, 2], [80, 0, 3]].map { |i| Item.new(*i) }.freeze

def parse_boss(input)
  input.scan(/\d+/).map(&:to_i)
end

def loadouts
  ring_sets = (0..2).flat_map { |n| RINGS.combination(n).to_a }
  WEAPONS.product(ARMORS, ring_sets).map do |weapon, armor, rings|
    items = [weapon, armor, *rings]
    Item.new(items.sum(&:cost), items.sum(&:damage), items.sum(&:armor))
  end
end

def player_wins?(player_hp, gear, boss)
  boss_hp, boss_damage, boss_armor = boss
  turns_to_kill_boss = boss_hp.fdiv([gear.damage - boss_armor, 1].max).ceil
  turns_to_kill_player = player_hp.fdiv([boss_damage - gear.armor, 1].max).ceil
  turns_to_kill_boss <= turns_to_kill_player
end

def solve(input, player_hp: 100)
  boss = parse_boss(input)
  loadouts.select { |gear| player_wins?(player_hp, gear, boss) }.map(&:cost).min
end

def solve2(input, player_hp: 100)
  boss = parse_boss(input)
  loadouts.reject { |gear| player_wins?(player_hp, gear, boss) }.map(&:cost).max
end

class AoCTest < Minitest::Test
  def test_player_wins_example
    assert player_wins?(8, Item.new(0, 5, 5), [12, 7, 2])
    refute player_wins?(8, Item.new(0, 5, 4), [12, 7, 2])
  end

  def test_solve_example
    assert_equal 8, solve("Hit Points: 1\nDamage: 0\nArmor: 0\n")
  end

  def test_solve_input
    assert_equal 78, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 74 + 102 + 100 + 80, solve2("Hit Points: 1000\nDamage: 100\nArmor: 100\n")
  end

  def test_solve2_input
    assert_equal 148, solve2(read_file('input.txt'))
  end
end
