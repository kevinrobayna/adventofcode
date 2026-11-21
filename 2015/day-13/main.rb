# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def parse_happiness(input)
  happiness = Hash.new { |h, k| h[k] = Hash.new(0) }
  input.scan(/(\w+) would (gain|lose) (\d+) happiness units by sitting next to (\w+)/).each do |a, sign, n, b|
    happiness[a][b] = sign == 'gain' ? n.to_i : -n.to_i
  end
  happiness
end

# Fix the first guest to avoid evaluating rotations of the same table.
def best_seating(happiness, guests)
  first, *rest = guests
  rest.permutation.map do |order|
    table = [first, *order]
    table.each_with_index.sum do |guest, i|
      neighbour = table[(i + 1) % table.size]
      happiness[guest][neighbour] + happiness[neighbour][guest]
    end
  end.max
end

def solve(input)
  happiness = parse_happiness(input)
  best_seating(happiness, happiness.keys)
end

def solve2(input)
  happiness = parse_happiness(input)
  best_seating(happiness, happiness.keys + [:me])
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    Alice would gain 54 happiness units by sitting next to Bob.
    Alice would lose 79 happiness units by sitting next to Carol.
    Alice would lose 2 happiness units by sitting next to David.
    Bob would gain 83 happiness units by sitting next to Alice.
    Bob would lose 7 happiness units by sitting next to Carol.
    Bob would lose 63 happiness units by sitting next to David.
    Carol would lose 62 happiness units by sitting next to Alice.
    Carol would gain 60 happiness units by sitting next to Bob.
    Carol would gain 55 happiness units by sitting next to David.
    David would gain 46 happiness units by sitting next to Alice.
    David would lose 7 happiness units by sitting next to Bob.
    David would gain 41 happiness units by sitting next to Carol.
  INPUT

  def test_solve_example
    assert_equal 330, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 664, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 286, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 640, solve2(read_file('input.txt'))
  end
end
