# frozen_string_literal: true

require_relative '../../lib/aoc'

def seat_id(pass)
  pass.tr('FBLR', '0101').to_i(2)
end

def solve(input)
  input.split.map { |p| seat_id(p) }.max
end

def solve2(input)
  ids = input.split.map { |p| seat_id(p) }.sort
  ids.each_cons(2).find { |a, b| b - a == 2 }.first + 1
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    BFFFBBFRRR
    FFFBBBFRRR
    BBFFBBFRLL
  INPUT

  def test_seat_ids
    assert_equal 357, seat_id('FBFBBFFRLR')
    assert_equal 567, seat_id('BFFFBBFRRR')
    assert_equal 119, seat_id('FFFBBBFRRR')
    assert_equal 820, seat_id('BBFFBBFRLL')
  end

  def test_solve_example
    assert_equal 820, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 906, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 4, solve2("FFFFFFFLRL\nFFFFFFFLRR\nFFFFFFFRLR\nFFFFFFFRRL\n")
  end

  def test_solve2_input
    assert_equal 519, solve2(read_file('input.txt'))
  end
end
