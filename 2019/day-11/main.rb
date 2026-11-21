# frozen_string_literal: true

require_relative '../../lib/aoc'
require_relative '../intcode'
require_relative '../ocr'

# Runs the painting robot; `brain` responds to #run(color) with [paint, turn] and #halted?.
def paint(brain, start_color)
  panels = Hash.new(0)
  pos = [0, 0]
  panels[pos] = start_color
  dir = [0, -1]
  loop do
    color, turn = brain.run(panels[pos])
    break unless turn

    panels[pos] = color
    dir = turn.zero? ? [dir[1], -dir[0]] : [-dir[1], dir[0]]
    pos = [pos[0] + dir[0], pos[1] + dir[1]]
  end
  panels
end

def solve(input)
  paint(Intcode.new(input), 0).size
end

def render_panels(panels)
  white = panels.select { |_, c| c == 1 }.keys
  xs = white.map(&:first).minmax
  ys = white.map(&:last).minmax
  (ys[0]..ys[1]).map { |y| (xs[0]..xs[1]).map { |x| panels[[x, y]] == 1 ? '#' : '.' }.join }
end

def solve2(input)
  OCR.decode(render_panels(paint(Intcode.new(input), 1)))
end

# Replays the scripted outputs from the puzzle description.
class ScriptedBrain
  def initialize(outputs) = @outputs = outputs.each_slice(2).to_a

  def run(_color) = @outputs.shift || []
end

class AoCTest < Minitest::Test
  def test_solve_example
    panels = paint(ScriptedBrain.new([1, 0, 0, 0, 1, 0, 1, 0, 0, 1, 1, 0, 1, 0]), 0)

    assert_equal 6, panels.size
    assert_equal ['..#', '..#', '##.'], render_panels(panels)
  end

  def test_solve_input
    assert_equal 1909, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 'JUFEKHPH', solve2(read_file('input.txt'))
  end
end
