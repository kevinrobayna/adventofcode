# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

class Cave
  attr_reader :tx, :ty

  def initialize(input, margin: 60)
    @depth, @tx, @ty = input.scan(/\d+/).map(&:to_i)
    @w = @tx + margin
    @h = @ty + margin
    @erosion = Array.new(@h) { Array.new(@w) }
    @h.times do |y|
      @w.times do |x|
        geo = if (x.zero? && y.zero?) || (x == @tx && y == @ty) then 0
              elsif y.zero? then x * 16_807
              elsif x.zero? then y * 48_271
              else @erosion[y][x - 1] * @erosion[y - 1][x]
              end
        @erosion[y][x] = (geo + @depth) % 20_183
      end
    end
  end

  # 0 rocky, 1 wet, 2 narrow
  def type(x, y)
    @erosion[y][x] % 3
  end

  def risk
    (0..@ty).sum { |y| (0..@tx).sum { |x| type(x, y) } }
  end

  # Tools: 0 neither, 1 torch, 2 climbing gear. A tool is allowed in a region iff tool != type.
  # Dijkstra with a bucket queue (edge weights are 1 or 7).
  def fastest
    best = Array.new(@h * @w * 3, Float::INFINITY)
    start = 1
    best[start] = 0
    buckets = [[start]]
    t = 0
    loop do
      (buckets[t] || []).each do |state|
        next if best[state] < t

        tool = state % 3
        cell = state / 3
        x = cell % @w
        y = cell / @w
        return t if x == @tx && y == @ty && tool == 1

        other = 3 - tool - type(x, y)
        relax(best, buckets, (cell * 3) + other, t + 7)
        [[x + 1, y], [x - 1, y], [x, y + 1], [x, y - 1]].each do |nx, ny|
          next if nx.negative? || ny.negative? || nx >= @w || ny >= @h || type(nx, ny) == tool

          relax(best, buckets, (((ny * @w) + nx) * 3) + tool, t + 1)
        end
      end
      buckets[t] = nil
      t += 1
    end
  end

  private

  def relax(best, buckets, state, time)
    return unless time < best[state]

    best[state] = time
    (buckets[time] ||= []) << state
  end
end

def solve(input)
  Cave.new(input, margin: 1).risk
end

def solve2(input)
  Cave.new(input).fastest
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    depth: 510
    target: 10,10
  INPUT

  def test_solve_example
    assert_equal 114, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 6208, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 45, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 1039, solve2(read_file('input.txt'))
  end
end
