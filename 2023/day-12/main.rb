# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def solve(input, folds: 1)
  input.each_line.sum do |line|
    springs, rules = line.split
    # Unfold, then append a '.' so a group running into the end of the row is closed naturally.
    springs = "#{([springs] * folds).join('?')}."
    rules = rules.split(',').map(&:to_i) * folds
    count(springs, rules)
  end
end

def solve2(input, folds: 5)
  solve(input, folds: folds)
end

# Arrangements of springs given the group sizes, memoised on [position, rule index, current '#' run].
def count(springs, rules)
  cache = {}
  walk = lambda do |pos, rule, group|
    return rule == rules.length && group.zero? ? 1 : 0 if pos == springs.length

    cache[[pos, rule, group]] ||= begin
      char = springs[pos]
      total = 0
      total += walk.call(pos + 1, rule, group + 1) if char != '.' && rule < rules.length && group < rules[rule] # place '#'
      if char != '#'
        if group.zero?
          total += walk.call(pos + 1, rule, 0) # place '.'
        elsif group == rules[rule]
          total += walk.call(pos + 1, rule + 1, 0) # close the group
        end
      end
      total
    end
  end
  walk.call(0, 0, 0)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    ???.### 1,1,3
    .??..??...?##. 1,1,3
    ?#?#?#?#?#?#?#? 1,3,1,6
    ????.#...#... 4,1,1
    ????.######..#####. 1,6,5
    ?###???????? 3,2,1
  INPUT

  def test_solve_example
    assert_equal 21, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 7460, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 525_152, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 6_720_660_274_964, solve2(read_file('input.txt'))
  end
end
