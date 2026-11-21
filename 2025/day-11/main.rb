# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

# Counts paths in the device DAG, memoised per (from, to).
class Devices
  def initialize(input)
    @edges = input.lines.to_h do |line|
      name, outs = line.split(':')
      [name.strip, outs.split]
    end
    @memo = {}
  end

  def paths(from, to)
    return 1 if from == to

    @memo[[from, to]] ||= @edges.fetch(from, []).sum { |n| paths(n, to) }
  end

  def paths_through(from, to, stops)
    stops.permutation.sum { |order| [from, *order, to].each_cons(2).map { |a, b| paths(a, b) }.reduce(:*) }
  end
end

def solve(input)
  Devices.new(input).paths('you', 'out')
end

def solve2(input)
  Devices.new(input).paths_through('svr', 'out', %w[dac fft])
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    aaa: you hhh
    you: bbb ccc
    bbb: ddd eee
    ccc: ddd eee fff
    ddd: ggg
    eee: out
    fff: out
    ggg: out
    hhh: ccc fff iii
    iii: out
  INPUT

  EXAMPLE2 = <<~INPUT
    svr: aaa bbb
    aaa: fft
    fft: ccc
    bbb: tty
    tty: ccc
    ccc: ddd eee
    ddd: hub
    hub: fff
    eee: dac
    dac: fff
    fff: ggg hhh
    ggg: out
    hhh: out
  INPUT

  def test_solve_example
    assert_equal 5, solve(EXAMPLE)
  end

  def test_solve2_example
    assert_equal 2, solve2(EXAMPLE2)
  end

  def test_all_paths_example2
    assert_equal 8, Devices.new(EXAMPLE2).paths('svr', 'out')
  end

  def test_solve_input
    assert_equal 511, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 458_618_114_529_380, solve2(read_file('input.txt'))
  end
end
