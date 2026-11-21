# frozen_string_literal: true

require_relative '../../lib/aoc'

def parse(input)
  input.lines.map do |line|
    ingredients, allergens = line.match(/(.*) \(contains (.*)\)/).captures
    [ingredients.split, allergens.split(', ')]
  end
end

# allergen => set of ingredients that could contain it
def candidates(foods)
  foods.each_with_object({}) do |(ingredients, allergens), acc|
    allergens.each { |a| acc[a] = acc.key?(a) ? acc[a] & ingredients : ingredients }
  end
end

def solve(input)
  foods = parse(input)
  unsafe = candidates(foods).values.flatten.uniq
  foods.sum { |ingredients, _| (ingredients - unsafe).size }
end

def solve2(input)
  remaining = candidates(parse(input))
  resolved = {}
  until remaining.empty?
    allergen, (ingredient,) = remaining.find { |_, ing| ing.size == 1 }
    resolved[allergen] = ingredient
    remaining.delete(allergen)
    remaining.transform_values! { |ing| ing - [ingredient] }
  end
  resolved.sort.map(&:last).join(',')
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
    trh fvjkl sbzzf mxmxvkd (contains dairy)
    sqjhc fvjkl (contains soy)
    sqjhc mxmxvkd sbzzf (contains fish)
  INPUT

  def test_solve_example
    assert_equal 5, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 2573, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 'mxmxvkd,sqjhc,fvjkl', solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 'bjpkhx,nsnqf,snhph,zmfqpn,qrbnjtj,dbhfd,thn,sthnsg', solve2(read_file('input.txt'))
  end
end
