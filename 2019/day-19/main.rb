# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end
require_relative '../intcode'

def drone(input)
  program = Intcode.parse(input)
  ->(x, y) { Intcode.new(program).run(x, y).first == 1 }
end

def grid_beam(text)
  rows = text.split("\n")
  ->(x, y) { rows[y]&.[](x) == '#' }
end

def affected(beam, size)
  (0...size).sum { |y| (0...size).count { |x| beam.call(x, y) } }
end

def solve(input)
  affected(drone(input), 50)
end

# Tracks the beam's left edge row by row; the square's bottom-left corner sits on it.
# Rows near the emitter may be empty, so the scan starts at `size`.
def closest_square(beam, size)
  x = 0
  y = size - 1
  loop do
    y += 1
    start = x
    x += 1 until beam.call(x, y) || x > start + (y * 4)
    next x = start unless beam.call(x, y)

    return (x * 10_000) + y - size + 1 if beam.call(x + size - 1, y - size + 1)
  end
end

def solve2(input)
  closest_square(drone(input), 100)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    #.........
    .#........
    ..##......
    ...###....
    ....###...
    .....####.
    ......####
    ......####
    .......###
    ........##
  INPUT

  def test_solve_example
    assert_equal 27, affected(grid_beam(EXAMPLE), 10)
  end

  def test_solve_input
    assert_equal 166, solve(read_file('input.txt'))
  end

  def test_solve2_example
    beam = ->(x, y) { x >= y * 1.3 && x <= y * 1.9 }
    brute = (0..400).flat_map { |y| (0..400).map { |x| [x, y] } }
                    .find { |x, y| [[x, y], [x + 9, y], [x, y + 9], [x + 9, y + 9]].all? { beam.call(*it) } }

    assert_equal (brute[0] * 10_000) + brute[1], closest_square(beam, 10)
  end

  def test_solve2_input
    assert_equal 3_790_981, solve2(read_file('input.txt'))
  end
end
