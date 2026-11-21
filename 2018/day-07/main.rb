# frozen_string_literal: true

require_relative '../../lib/aoc'

def dependencies(input)
  deps = Hash.new { |h, k| h[k] = [] }
  input.scan(/Step (\w) must be finished before step (\w)/).each do |a, b|
    deps[a]
    deps[b] << a
  end
  deps
end

def solve(input)
  deps = dependencies(input)
  done = []
  done << deps.keys.reject { |k| done.include?(k) }.select { |k| (deps[k] - done).empty? }.min until done.size == deps.size
  done.join
end

def solve2(input, workers: 5, base: 60)
  deps = dependencies(input)
  done = []
  in_progress = {} # step => finish time
  time = 0
  loop do
    available = deps.keys.reject { |k| done.include?(k) || in_progress.key?(k) }
                    .select { |k| (deps[k] - done).empty? }.sort
    available.first(workers - in_progress.size).each { |s| in_progress[s] = time + base + s.ord - 64 }
    return time if in_progress.empty?

    time = in_progress.values.min
    in_progress.select { |_, t| t == time }.each_key do |s|
      done << s
      in_progress.delete(s)
    end
  end
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    Step C must be finished before step A can begin.
    Step C must be finished before step F can begin.
    Step A must be finished before step B can begin.
    Step A must be finished before step D can begin.
    Step B must be finished before step E can begin.
    Step D must be finished before step E can begin.
    Step F must be finished before step E can begin.
  INPUT

  def test_solve_example
    assert_equal 'CABDFE', solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 'IOFSJQDUWAPXELNVYZMHTBCRGK', solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 15, solve2(EXAMPLE, workers: 2, base: 0)
  end

  def test_solve2_input
    assert_equal 931, solve2(read_file('input.txt'))
  end
end
