# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end
require_relative '../intcode'

# Runs the 50-computer network. Yields each packet sent to address 255 together with an idle flag
# whenever the network goes idle; the block returns a value to stop with, or a packet to inject into 0.
def network(input, size: 50)
  program = Intcode.parse(input)
  nodes = Array.new(size) { |i| Intcode.new(program) << i }
  queues = Array.new(size) { [] }
  nat = nil
  loop do
    sent = false
    nodes.each_with_index do |vm, i|
      inbox = queues[i].empty? ? [-1] : queues[i].shift(queues[i].size)
      vm.run(inbox).each_slice(3) do |dest, x, y|
        sent = true
        next queues[dest].push(x, y) if dest < size

        nat = [x, y]
        result = yield nat, false
        return result if result
      end
    end
    next if sent || queues.any?(&:any?) || nat.nil?

    result = yield nat, true
    return result if result

    queues[0].push(*nat)
  end
end

def solve(input)
  network(input) { |(_, y), _| y }
end

def solve2(input)
  last = nil
  network(input) do |(_, y), idle|
    next unless idle
    break y if y == last

    last = y
    nil
  end
end

class AoCTest < Minitest::Test
  # A tiny Intcode node: reads its address, sends [255, address, address * 10] once, then idles reading input.
  NODE = '3,100,104,255,4,100,1002,100,10,101,4,101,3,102,1105,1,12'

  def test_solve_example
    assert_equal 0, solve(NODE)
  end

  def test_solve2_example
    assert_equal 490, solve2(NODE)
  end

  def test_solve_input
    assert_equal 19_724, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 15_252, solve2(read_file('input.txt'))
  end
end
