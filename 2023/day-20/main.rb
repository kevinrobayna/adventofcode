# frozen_string_literal: true

require_relative '../../lib/aoc'

# Pulse network: modules is name => [type, destinations]; state holds flip-flop and conjunction memory.
class Network
  attr_reader :modules

  def initialize(input)
    @modules = input.lines.to_h do |line|
      name, dests = line.strip.split(' -> ')
      type = name[0] if '%&'.include?(name[0])
      [type ? name[1..] : name, [type, dests.split(', ')]]
    end
    @flip = Hash.new(false)
    @memory = Hash.new { |h, k| h[k] = {} }
    @modules.each { |name, (_, dests)| dests.each { |d| @memory[d][name] = false } }
  end

  def inputs(name)
    @memory[name].keys
  end

  # Presses the button once; yields every [source, high?, destination] pulse sent.
  def press
    queue = [['button', false, 'broadcaster']]
    until queue.empty?
      src, high, dest = queue.shift
      yield src, high, dest
      type, dests = @modules[dest]
      next unless dests

      out = case type
            when '%'
              next if high

              @flip[dest] = !@flip[dest]
            when '&'
              @memory[dest][src] = high
              !@memory[dest].values.all?
            else
              high
            end
      dests.each { |d| queue << [dest, out, d] }
    end
  end
end

def solve(input)
  network = Network.new(input)
  counts = [0, 0]
  1000.times { network.press { |_, high, _| counts[high ? 1 : 0] += 1 } }
  counts.reduce(:*)
end

# rx is fed by a single conjunction whose inputs each go high on their own cycle; rx fires at the LCM.
def solve2(input)
  network = Network.new(input)
  feeder = network.inputs('rx').first
  cycles = network.inputs(feeder).to_h { [it, nil] }
  presses = 0
  while cycles.values.any?(&:nil?)
    presses += 1
    network.press { |src, high, dest| cycles[src] ||= presses if high && dest == feeder }
  end
  cycles.values.reduce(1, :lcm)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    broadcaster -> a, b, c
    %a -> b
    %b -> c
    %c -> inv
    &inv -> a
  INPUT

  EXAMPLE2 = <<~INPUT
    broadcaster -> a
    %a -> inv, con
    &inv -> b
    %b -> con
    &con -> output
  INPUT

  def test_solve_example
    assert_equal 32_000_000, solve(EXAMPLE)
    assert_equal 11_687_500, solve(EXAMPLE2)
  end

  def test_solve_input
    assert_equal 743_871_576, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 244_151_741_342_687, solve2(read_file('input.txt'))
  end
end
