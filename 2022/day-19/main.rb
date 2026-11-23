# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

ORE = 0
CLAY = 1
OBSIDIAN = 2
GEODE = 3

# costs[robot] = [ore, clay, obsidian] needed to build that robot.
Blueprint = Struct.new(:id, :costs) do
  def max_useful
    @max_useful ||= [costs.map { |c| c[ORE] }.max, costs[OBSIDIAN][CLAY], costs[GEODE][OBSIDIAN]]
  end
end

def parse_blueprints(input)
  input.each_line.map do |line|
    id, ore, clay, obs_ore, obs_clay, geo_ore, geo_obs = line.scan(/\d+/).map(&:to_i)
    Blueprint.new(id, [[ore, 0, 0], [clay, 0, 0], [obs_ore, obs_clay, 0], [geo_ore, 0, geo_obs]])
  end
end

# DFS that chooses which robot to build next and skips ahead to when it can be afforded.
def max_geodes(blueprint, minutes)
  best = 0
  search = lambda do |time, robots, stock, geodes|
    best = geodes if geodes > best
    return if geodes + (time * (time - 1) / 2) <= best

    GEODE.downto(ORE) do |robot|
      next if robot < GEODE && robots[robot] >= blueprint.max_useful[robot]

      cost = blueprint.costs[robot]
      wait = 0
      affordable = (ORE..OBSIDIAN).all? do |r|
        next true if cost[r] <= stock[r]
        next false if robots[r].zero?

        wait = [wait, (cost[r] - stock[r] + robots[r] - 1) / robots[r]].max
      end
      next unless affordable

      remaining = time - wait - 1
      next if remaining <= 0

      new_stock = (ORE..OBSIDIAN).map { |r| stock[r] + (robots[r] * (wait + 1)) - cost[r] }
      if robot == GEODE
        search.call(remaining, robots, new_stock, geodes + remaining)
      else
        new_robots = robots.dup
        new_robots[robot] += 1
        search.call(remaining, new_robots, new_stock, geodes)
      end
    end
  end
  search.call(minutes, [1, 0, 0], [0, 0, 0], 0)
  best
end

def solve(input)
  parse_blueprints(input).sum { |bp| bp.id * max_geodes(bp, 24) }
end

def solve2(input)
  parse_blueprints(input).first(3).map { |bp| max_geodes(bp, 32) }.reduce(:*)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.
    Blueprint 2: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. Each geode robot costs 3 ore and 12 obsidian.
  INPUT

  def test_solve_example
    assert_equal 33, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 2193, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 56 * 62, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 7200, solve2(read_file('input.txt'))
  end
end
