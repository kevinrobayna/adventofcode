# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

# Parses the valves, keeping only AA and valves with positive flow, with shortest distances between them.
def parse_valves(input)
  rates = {}
  tunnels = {}
  input.each_line do |line|
    name, *others = line.scan(/[A-Z]{2}/)
    rates[name] = line[/\d+/].to_i
    tunnels[name] = others
  end

  names = rates.keys
  dist = names.to_h { |a| [a, names.to_h { |b| [b, a == b ? 0 : Float::INFINITY] }] }
  tunnels.each { |a, list| list.each { |b| dist[a][b] = 1 } }
  names.each do |k|
    names.each do |i|
      names.each do |j|
        through = dist[i][k] + dist[k][j]
        dist[i][j] = through if through < dist[i][j]
      end
    end
  end

  useful = names.select { |n| rates[n].positive? }
  [useful.map { |n| rates[n] }, useful.map { |a| useful.map { |b| dist[a][b] } }, useful.map { |n| dist['AA'][n] }]
end

# Best total pressure for each set (bitmask) of opened valves, within the given minutes.
def best_by_valve_set(input, minutes)
  rates, dist, from_start = parse_valves(input)
  best = Hash.new(0)
  explore = lambda do |pos, time_left, mask, pressure|
    best[mask] = pressure if pressure > best[mask]
    rates.each_index do |nxt|
      next if mask[nxt] == 1

      remaining = time_left - (pos ? dist[pos][nxt] : from_start[nxt]) - 1
      next if remaining <= 0

      explore.call(nxt, remaining, mask | (1 << nxt), pressure + (remaining * rates[nxt]))
    end
  end
  explore.call(nil, minutes, 0, 0)
  [best, rates.size]
end

def solve(input)
  best_by_valve_set(input, 30).first.values.max
end

def solve2(input)
  best, count = best_by_valve_set(input, 26)
  full = (1 << count) - 1
  # best_subset[m] = best pressure using any subset of m.
  best_subset = Array.new(full + 1) { |m| best[m] }
  count.times do |bit|
    (0..full).each do |m|
      next if m[bit].zero?

      other = best_subset[m ^ (1 << bit)]
      best_subset[m] = other if other > best_subset[m]
    end
  end
  best.map { |mask, pressure| pressure + best_subset[full ^ mask] }.max
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
    Valve BB has flow rate=13; tunnels lead to valves CC, AA
    Valve CC has flow rate=2; tunnels lead to valves DD, BB
    Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
    Valve EE has flow rate=3; tunnels lead to valves FF, DD
    Valve FF has flow rate=0; tunnels lead to valves EE, GG
    Valve GG has flow rate=0; tunnels lead to valves FF, HH
    Valve HH has flow rate=22; tunnel leads to valve GG
    Valve II has flow rate=0; tunnels lead to valves AA, JJ
    Valve JJ has flow rate=21; tunnel leads to valve II
  INPUT

  def test_solve_example
    assert_equal 1651, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 2320, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 1707, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 2967, solve2(read_file('input.txt'))
  end
end
