# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def parse_ingredients(input)
  input.lines.map { |line| line.scan(/-?\d+/).map(&:to_i) }
end

# Yields every way to split `total` teaspoons across `count` ingredients.
def each_split(total, count, &)
  return yield [total] if count == 1

  (0..total).each do |n|
    each_split(total - n, count - 1) { |rest| yield([n, *rest]) }
  end
end

def best_cookie(input, calories: nil)
  ingredients = parse_ingredients(input)
  best = 0
  each_split(100, ingredients.size) do |amounts|
    totals = ingredients.transpose.map { |prop| [prop.zip(amounts).sum { |p, a| p * a }, 0].max }
    next if calories && totals.last != calories

    best = [best, totals[0..3].reduce(:*)].max
  end
  best
end

def solve(input)
  best_cookie(input)
end

def solve2(input)
  best_cookie(input, calories: 500)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
    Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3
  INPUT

  def test_solve_example
    assert_equal 62_842_880, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 18_965_440, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 57_600_000, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 15_862_900, solve2(read_file('input.txt'))
  end
end
