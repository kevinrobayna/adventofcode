# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def columns(input) = input.lines.map(&:strip).reject(&:empty?).map(&:chars).transpose.map(&:tally)

def solve(input)
  columns(input).map { |t| t.max_by(&:last).first }.join
end

def solve2(input)
  columns(input).map { |t| t.min_by(&:last).first }.join
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    eedadn
    drvtee
    eandsr
    raavrd
    atevrs
    tsrnev
    sdttsa
    rasrtv
    nssdts
    ntnada
    svetve
    tesnvt
    vntsnd
    vrdear
    dvrsen
    enarar
  INPUT

  def test_solve_example
    assert_equal 'easter', solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 'afwlyyyq', solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 'advent', solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 'bhkzekao', solve2(read_file('input.txt'))
  end
end
