# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

Group = Struct.new(:army, :units, :hp, :weak, :immune, :damage, :type, :initiative) do
  def power
    units * damage
  end

  def damage_to(other)
    return 0 if other.immune.include?(type)

    other.weak.include?(type) ? power * 2 : power
  end
end

def parse_armies(input, boost: 0)
  input.split("\n\n").flat_map do |block|
    name, *lines = block.lines(chomp: true)
    army = name.start_with?('Immune') ? :immune : :infection
    lines.join(' ').scan(/\d+ units.*?initiative \d+/).map do |line|
      units, hp, damage, initiative = line.scan(/\d+/).map(&:to_i).values_at(0, 1, -2, -1)
      traits = ->(kind) { line[/#{kind} to ([\w, ]+)/, 1]&.split(', ') || [] }
      type = line[/(\w+) damage/, 1]
      Group.new(army, units, hp, traits.call('weak'), traits.call('immune'),
                damage + (army == :immune ? boost : 0), type, initiative)
    end
  end
end

# Fights until one army is gone; returns [winning army, units left], or nil on a stalemate.
def fight(groups)
  loop do
    armies = groups.map(&:army).uniq
    return [armies.first, groups.sum(&:units)] if armies.size == 1

    targets = {}.compare_by_identity
    groups.sort_by { |g| [-g.power, -g.initiative] }.each do |g|
      choice = groups.reject { |e| e.army == g.army || targets.each_value.any? { |t| t.equal?(e) } }
                     .select { |e| g.damage_to(e).positive? }
                     .max_by { |e| [g.damage_to(e), e.power, e.initiative] }
      targets[g] = choice if choice
    end

    killed = 0
    groups.sort_by { |g| -g.initiative }.each do |g|
      target = targets[g]
      next if g.units <= 0 || target.nil?

      dead = [g.damage_to(target) / target.hp, target.units].min
      target.units -= dead
      killed += dead
    end
    return nil if killed.zero?

    groups.select! { |g| g.units.positive? }
  end
end

def solve(input)
  fight(parse_armies(input)).last
end

def solve2(input)
  (1..).each do |boost|
    winner, units = fight(parse_armies(input, boost: boost))
    return units if winner == :immune
  end
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    Immune System:
    17 units each with 5390 hit points (weak to radiation, bludgeoning) with an attack that does 4507 fire damage at initiative 2
    989 units each with 1274 hit points (immune to fire; weak to bludgeoning, slashing) with an attack that does 25 slashing damage at initiative 3

    Infection:
    801 units each with 4706 hit points (weak to radiation) with an attack that does 116 bludgeoning damage at initiative 1
    4485 units each with 2961 hit points (immune to radiation; weak to fire, cold) with an attack that does 12 slashing damage at initiative 4
  INPUT

  def test_solve_example
    assert_equal 5216, solve(EXAMPLE)
  end

  def test_boost_example
    assert_equal [:immune, 51], fight(parse_armies(EXAMPLE, boost: 1570))
  end

  def test_solve_input
    assert_equal 15_493, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 51, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 1045, solve2(read_file('input.txt'))
  end
end
