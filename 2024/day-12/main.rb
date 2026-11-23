# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

NEIGHBOURS = [[-1, 0], [0, 1], [1, 0], [0, -1]].freeze

def regions(input)
  grid = input.lines.map(&:chomp)
  plant = ->(r, c) { r.between?(0, grid.size - 1) && c.between?(0, grid[r].size - 1) ? grid[r][c] : nil }
  seen = Set.new
  grid.each_index.flat_map do |r|
    grid[r].size.times.filter_map do |c|
      next if seen.include?([r, c])

      region = Set[[r, c]]
      queue = [[r, c]]
      until queue.empty?
        cr, cc = queue.pop
        NEIGHBOURS.each do |dr, dc|
          cell = [cr + dr, cc + dc]
          next unless plant.call(*cell) == grid[r][c] && region.add?(cell)

          queue << cell
        end
      end
      seen.merge(region)
      region
    end
  end
end

def perimeter(region)
  region.sum { |r, c| NEIGHBOURS.count { |dr, dc| !region.include?([r + dr, c + dc]) } }
end

# Number of sides equals number of corners; check convex and concave corners per cell.
def sides(region)
  region.sum do |r, c|
    NEIGHBOURS.each_index.count do |i|
      a = NEIGHBOURS[i]
      b = NEIGHBOURS[(i + 1) % 4]
      has_a = region.include?([r + a[0], c + a[1]])
      has_b = region.include?([r + b[0], c + b[1]])
      diagonal = region.include?([r + a[0] + b[0], c + a[1] + b[1]])
      (!has_a && !has_b) || (has_a && has_b && !diagonal)
    end
  end
end

def solve(input)
  regions(input).sum { _1.size * perimeter(_1) }
end

def solve2(input)
  regions(input).sum { _1.size * sides(_1) }
end

class AoCTest < Minitest::Test
  SMALL = <<~INPUT
    AAAA
    BBCD
    BBCC
    EEEC
  INPUT

  NESTED = <<~INPUT
    OOOOO
    OXOXO
    OOOOO
    OXOXO
    OOOOO
  INPUT

  EXAMPLE = <<~INPUT
    RRRRIICCFF
    RRRRIICCCF
    VVRRRCCFFF
    VVRCCCJFFF
    VVVVCJJCFE
    VVIVCCJJEE
    VVIIICJJEE
    MIIIIIJJEE
    MIIISIJEEE
    MMMISSJEEE
  INPUT

  def test_solve_example
    assert_equal 140, solve(SMALL)
    assert_equal 772, solve(NESTED)
    assert_equal 1930, solve(EXAMPLE)
  end

  def test_solve2_example
    assert_equal 80, solve2(SMALL)
    assert_equal 436, solve2(NESTED)
    assert_equal 236, solve2(<<~INPUT)
      EEEEE
      EXXXX
      EEEEE
      EXXXX
      EEEEE
    INPUT
    assert_equal 368, solve2(<<~INPUT)
      AAAAAA
      AAABBA
      AAABBA
      ABBAAA
      ABBAAA
      AAAAAA
    INPUT
    assert_equal 1206, solve2(EXAMPLE)
  end

  def test_solve_input
    assert_equal 1_434_856, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 891_106, solve2(read_file('input.txt'))
  end
end
