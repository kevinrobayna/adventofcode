# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end
require_relative '../ocr'

def layers(input, width, height)
  input.strip.chars.each_slice(width * height).to_a
end

def solve(input, width: 25, height: 6)
  layer = layers(input, width, height).min_by { it.count('0') }
  layer.count('1') * layer.count('2')
end

def render(input, width: 25, height: 6)
  layers(input, width, height).transpose.map { |px| px.find { it != '2' } == '1' ? '#' : '.' }
                              .each_slice(width).map(&:join)
end

def solve2(input)
  OCR.decode(render(input))
end

class AoCTest < Minitest::Test
  def test_solve_example
    assert_equal 1, solve('123456789012', width: 3, height: 2)
  end

  def test_solve_input
    assert_equal 1320, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal %w[.# #.], render('0222112222120000', width: 2, height: 2)
  end

  def test_solve2_input
    assert_equal 'RCYKR', solve2(read_file('input.txt'))
  end
end
