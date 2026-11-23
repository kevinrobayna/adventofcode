# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

# Minimal binary min-heap of [priority, value] pairs.
class MinHeap
  def initialize
    @items = []
  end

  def empty?
    @items.empty?
  end

  def push(priority, value)
    @items << [priority, value]
    i = @items.size - 1
    while i.positive?
      parent = (i - 1) / 2
      break if @items[parent][0] <= @items[i][0]

      @items[parent], @items[i] = @items[i], @items[parent]
      i = parent
    end
  end

  def pop
    top = @items.first
    last = @items.pop
    return top if @items.empty?

    @items[0] = last
    i = 0
    loop do
      smallest = i
      [(2 * i) + 1, (2 * i) + 2].each do |child|
        smallest = child if child < @items.size && @items[child][0] < @items[smallest][0]
      end
      break if smallest == i

      @items[smallest], @items[i] = @items[i], @items[smallest]
      i = smallest
    end
    top
  end
end

# Dijkstra over (row, col, axis) where each move turns 90 degrees and goes min..max blocks straight.
def min_heat_loss(input, min_steps, max_steps)
  grid = input.lines.map { it.strip.chars.map(&:to_i) }
  rows = grid.length
  cols = grid.first.length
  best = {}
  heap = MinHeap.new
  [0, 1].each do |axis|
    heap.push(0, [0, 0, axis])
    best[[0, 0, axis]] = 0
  end

  until heap.empty?
    cost, (r, c, axis) = heap.pop
    return cost if r == rows - 1 && c == cols - 1
    next if cost > best[[r, c, axis]]

    # axis 0 = last move vertical, so now move horizontally (and vice versa)
    dirs = axis.zero? ? [[0, 1], [0, -1]] : [[1, 0], [-1, 0]]
    dirs.each do |dr, dc|
      total = cost
      (1..max_steps).each do |step|
        nr = r + (dr * step)
        nc = c + (dc * step)
        break if nr.negative? || nc.negative? || nr >= rows || nc >= cols

        total += grid[nr][nc]
        next if step < min_steps

        key = [nr, nc, 1 - axis]
        next if best.key?(key) && best[key] <= total

        best[key] = total
        heap.push(total, key)
      end
    end
  end
end

def solve(input)
  min_heat_loss(input, 1, 3)
end

def solve2(input)
  min_heat_loss(input, 4, 10)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    2413432311323
    3215453535623
    3255245654254
    3446585845452
    4546657867536
    1438598798454
    4457876987766
    3637877979653
    4654967986887
    4564679986453
    1224686865563
    2546548887735
    4322674655533
  INPUT

  EXAMPLE2 = <<~INPUT
    111111111111
    999999999991
    999999999991
    999999999991
    999999999991
  INPUT

  def test_solve_example
    assert_equal 102, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 845, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 94, solve2(EXAMPLE)
    assert_equal 71, solve2(EXAMPLE2)
  end

  def test_solve2_input
    assert_equal 993, solve2(read_file('input.txt'))
  end
end
