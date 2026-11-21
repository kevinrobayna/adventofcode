# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

# Spell: cost, instant damage, instant heal, effect turns
SPELLS = {
  missile: { cost: 53, damage: 4, heal: 0, turns: 0 },
  drain: { cost: 73, damage: 2, heal: 2, turns: 0 },
  shield: { cost: 113, damage: 0, heal: 0, turns: 6 },
  poison: { cost: 173, damage: 0, heal: 0, turns: 6 },
  recharge: { cost: 229, damage: 0, heal: 0, turns: 5 }
}.freeze

State = Struct.new(:hp, :mana, :boss_hp, :shield, :poison, :recharge)

def apply_effects(state)
  state.boss_hp -= 3 if state.poison.positive?
  state.mana += 101 if state.recharge.positive?
  state.shield -= 1 if state.shield.positive?
  state.poison -= 1 if state.poison.positive?
  state.recharge -= 1 if state.recharge.positive?
end

def cast(state, spell)
  info = SPELLS.fetch(spell)
  state.mana -= info[:cost]
  state.boss_hp -= info[:damage]
  state.hp += info[:heal]
  state[spell] = info[:turns] if info[:turns].positive?
end

def castable?(state, spell)
  info = SPELLS.fetch(spell)
  info[:cost] <= state.mana && (info[:turns].zero? || state[spell].zero?)
end

# Plays one full round (player turn + boss turn). Returns the new state, :win or nil (loss).
def play_round(state, spell, boss_damage, hard)
  state = state.dup
  state.hp -= 1 if hard
  return nil if state.hp <= 0

  apply_effects(state)
  return :win if state.boss_hp <= 0
  return nil unless castable?(state, spell)

  cast(state, spell)
  return :win if state.boss_hp <= 0

  armor = state.shield.positive? ? 7 : 0
  apply_effects(state)
  return :win if state.boss_hp <= 0

  state.hp -= [boss_damage - armor, 1].max
  state.hp.positive? ? state : nil
end

# Dijkstra over game states ordered by mana spent; :win is the terminal state.
def least_mana(input, hp:, mana:, hard: false)
  boss_hp, boss_damage = input.scan(/\d+/).map(&:to_i)
  queue = [[0, State.new(hp, mana, boss_hp, 0, 0, 0)]]
  seen = Set.new
  until queue.empty?
    spent, state = queue.shift
    return spent if state == :win
    next unless seen.add?(state.to_a)

    SPELLS.each do |spell, info|
      next_state = play_round(state, spell, boss_damage, hard)
      next unless next_state

      cost = spent + info[:cost]
      index = queue.bsearch_index { |s, _| s > cost } || queue.size
      queue.insert(index, [cost, next_state])
    end
  end
end

def solve(input, hp: 50, mana: 500)
  least_mana(input, hp:, mana:)
end

def solve2(input, hp: 50, mana: 500)
  least_mana(input, hp:, mana:, hard: true)
end

class AoCTest < Minitest::Test
  def test_solve_example
    assert_equal 173 + 53, solve("Hit Points: 13\nDamage: 8\n", hp: 10, mana: 250)
    assert_equal 229 + 113 + 73 + 173 + 53, solve("Hit Points: 14\nDamage: 8\n", hp: 10, mana: 250)
  end

  def test_solve_input
    assert_equal 953, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 1289, solve2(read_file('input.txt'))
  end
end
