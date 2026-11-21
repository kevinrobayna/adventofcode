# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def parse_rocks(input)
  rocks = Set.new
  input.each_line do |line|
    line.scan(/(\d+),(\d+)/).map { |p| p.map(&:to_i) }.each_cons(2) do |(x1, y1), (x2, y2)|
      ([x1, x2].min..[x1, x2].max).each do |x|
        ([y1, y2].min..[y1, y2].max).each { |y| rocks << [x, y] }
      end
    end
  end
  rocks
end

# Drops sand from 500,0 until it falls into the abyss (no floor) or the source is blocked (floor).
def pour_sand(input, floor:)
  blocked = parse_rocks(input)
  max_y = blocked.map(&:last).max
  count = 0
  until blocked.include?([500, 0])
    x = 500
    y = 0
    loop do
      break if floor && y == max_y + 1
      return count if !floor && y > max_y

      nx = [x, x - 1, x + 1].find { |cx| !blocked.include?([cx, y + 1]) }
      break unless nx

      x = nx
      y += 1
    end
    blocked << [x, y]
    count += 1
  end
  count
end

def solve(input)
  pour_sand(input, floor: false)
end

def solve2(input)
  pour_sand(input, floor: true)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    498,4 -> 498,6 -> 496,6
    503,4 -> 502,4 -> 502,9 -> 494,9
  INPUT

  def test_solve_example
    assert_equal 24, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 1068, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 93, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 27_936, solve2(read_file('input.txt'))
  end
end
