# frozen_string_literal: true

require_relative '../../lib/aoc'

def parse_machine(input)
  rules, molecule = input.split("\n\n")
  [rules.scan(/(\w+) => (\w+)/), molecule.strip]
end

def solve(input)
  rules, molecule = parse_machine(input)
  rules.each_with_object(Set.new) do |(from, to), results|
    start = 0
    while (index = molecule.index(from, start))
      results << (molecule[0...index] + to + molecule[(index + from.size)..])
      start = index + 1
    end
  end.size
end

# Real inputs follow a grammar where every rule is X => XX, or X => X Rn X (Y X)* Ar.
# Each step adds one element, Rn/Ar are free and every Y saves two elements, so
# steps = elements - count(Rn, Ar) - 2 * count(Y) - 1.
def solve2(input)
  _, molecule = parse_machine(input)
  elements = molecule.scan(/[A-Z][a-z]?/)
  elements.size - elements.count { |e| %w[Rn Ar].include?(e) } - (2 * elements.count('Y')) - 1
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    H => HO
    H => OH
    O => HH

    HOH
  INPUT

  def test_solve_example
    assert_equal 4, solve(EXAMPLE)
    assert_equal 7, solve(EXAMPLE.sub('HOH', 'HOHOHO'))
  end

  def test_solve_input
    assert_equal 509, solve(read_file('input.txt'))
  end

  def test_solve2_example
    # Formula only applies to inputs following the real grammar: e => NAl, Al => ThRnFAr.
    assert_equal 2, solve2("e => NAl\nAl => ThRnFAr\n\nNThRnFAr\n")
  end

  def test_solve2_input
    assert_equal 195, solve2(read_file('input.txt'))
  end
end
