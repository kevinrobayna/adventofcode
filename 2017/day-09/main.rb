# frozen_string_literal: true

require_relative '../../lib/aoc'

# Returns [total group score, non-cancelled garbage characters].
def process_stream(input)
  score = depth = garbage_count = 0
  garbage = cancel = false
  input.strip.each_char do |c|
    if cancel
      cancel = false
    elsif garbage
      case c
      when '!' then cancel = true
      when '>' then garbage = false
      else garbage_count += 1
      end
    else
      case c
      when '{' then depth += 1
      when '}'
        score += depth
        depth -= 1
      when '<' then garbage = true
      end
    end
  end
  [score, garbage_count]
end

def solve(input)
  process_stream(input)[0]
end

def solve2(input)
  process_stream(input)[1]
end

class AoCTest < Minitest::Test
  def test_solve_example
    {
      '{}' => 1, '{{{}}}' => 6, '{{},{}}' => 5, '{{{},{},{{}}}}' => 16, '{<a>,<a>,<a>,<a>}' => 1,
      '{{<ab>},{<ab>},{<ab>},{<ab>}}' => 9, '{{<!!>},{<!!>},{<!!>},{<!!>}}' => 9,
      '{{<a!>},{<a!>},{<a!>},{<ab>}}' => 3
    }.each { |stream, score| assert_equal score, solve(stream), stream }
  end

  def test_solve_input
    assert_equal 14_421, solve(read_file('input.txt'))
  end

  def test_solve2_example
    {
      '<>' => 0, '<random characters>' => 17, '<<<<>' => 3, '<{!>}>' => 2, '<!!>' => 0, '<!!!>>' => 0,
      '<{o"i!a,<{i<a>' => 10
    }.each { |stream, count| assert_equal count, solve2(stream), stream }
  end

  def test_solve2_input
    assert_equal 6_817, solve2(read_file('input.txt'))
  end
end
