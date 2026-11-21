# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

require 'json'

def sum_numbers(node, skip_red:)
  case node
  when Integer then node
  when Array then node.sum { |child| sum_numbers(child, skip_red:) }
  when Hash
    return 0 if skip_red && node.value?('red')

    node.values.sum { |child| sum_numbers(child, skip_red:) }
  else 0
  end
end

def solve(input)
  sum_numbers(JSON.parse(input), skip_red: false)
end

def solve2(input)
  sum_numbers(JSON.parse(input), skip_red: true)
end

class AoCTest < Minitest::Test
  def test_solve_example
    assert_equal 6, solve('[1,2,3]')
    assert_equal 6, solve('{"a":2,"b":4}')
    assert_equal 3, solve('[[[3]]]')
    assert_equal 3, solve('{"a":{"b":4},"c":-1}')
    assert_equal 0, solve('{"a":[-1,1]}')
    assert_equal 0, solve('[-1,{"a":1}]')
    assert_equal 0, solve('[]')
    assert_equal 0, solve('{}')
  end

  def test_solve_input
    assert_equal 156_366, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 6, solve2('[1,2,3]')
    assert_equal 4, solve2('[1,{"c":"red","b":2},3]')
    assert_equal 0, solve2('{"d":"red","e":[1,2,3,4],"f":5}')
    assert_equal 6, solve2('[1,"red",5]')
  end

  def test_solve2_input
    assert_equal 96_852, solve2(read_file('input.txt'))
  end
end
