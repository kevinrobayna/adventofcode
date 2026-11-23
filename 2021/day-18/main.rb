# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

# A snailfish number is stored flat as a list of [value, depth] pairs.
def parse_number(line)
  depth = 0
  line.scan(/\[|\]|\d+/).filter_map do |token|
    case token
    when '[' then depth += 1
                  nil
    when ']' then depth -= 1
                  nil
    else [token.to_i, depth]
    end
  end
end

def explode!(num)
  i = num.index { |_, depth| depth > 4 }
  return false unless i

  left, depth = num[i]
  right = num[i + 1][0]
  num[i - 1][0] += left if i.positive?
  num[i + 2][0] += right if i + 2 < num.size
  num[i, 2] = [[0, depth - 1]]
  true
end

def split!(num)
  i = num.index { |value, _| value >= 10 }
  return false unless i

  value, depth = num[i]
  num[i, 1] = [[value / 2, depth + 1], [(value + 1) / 2, depth + 1]]
  true
end

def add(a, b)
  num = (a + b).map { |value, depth| [value, depth + 1] }
  loop { break unless explode!(num) || split!(num) }
  num
end

def magnitude(num)
  num = num.map(&:dup)
  while num.size > 1
    depth = num.map(&:last).max
    i = num.each_index.find { |j| num[j][1] == depth && num[j + 1][1] == depth }
    num[i, 2] = [[(3 * num[i][0]) + (2 * num[i + 1][0]), depth - 1]]
  end
  num[0][0]
end

def solve(input)
  magnitude(input.split("\n").map { |l| parse_number(l) }.reduce { |a, b| add(a, b) })
end

def solve2(input)
  numbers = input.split("\n").map { |l| parse_number(l) }
  numbers.permutation(2).map { |a, b| magnitude(add(a.map(&:dup), b.map(&:dup))) }.max
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    [[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
    [[[5,[2,8]],4],[5,[[9,9],0]]]
    [6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
    [[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
    [[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
    [[6,[[7,3],[3,2]]],[[[3,8],[1,1]],2]]
    [[[[5,4],[7,7]],8],[[8,3],8]]
    [[9,3],[[9,9],[6,[4,9]]]]
    [[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
    [[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
  INPUT

  def test_magnitude
    assert_equal 3488, magnitude(parse_number('[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]'))
  end

  def test_solve_example
    assert_equal 4140, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 4124, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 3993, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 4673, solve2(read_file('input.txt'))
  end
end
