# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def parse_moves(input)
  input.strip.split(',').map do |m|
    args = m[1..].split('/')
    case m[0]
    when 's' then [:spin, m[1..].to_i]
    when 'x' then [:exchange, *args.map(&:to_i)]
    else [:partner, *args]
    end
  end
end

def dance(programs, moves)
  p = programs.dup
  moves.each do |op, a, b|
    case op
    when :spin then p = p[-a..] + p[0...-a]
    when :exchange then p[a], p[b] = p[b], p[a]
    else
      i = p.index(a)
      j = p.index(b)
      p[i] = b
      p[j] = a
    end
  end
  p
end

def solve(input, programs: 'abcdefghijklmnop')
  dance(programs, parse_moves(input))
end

def solve2(input, programs: 'abcdefghijklmnop', times: 1_000_000_000)
  moves = parse_moves(input)
  seen = [programs]
  current = programs
  loop do
    current = dance(current, moves)
    break if current == programs

    seen << current
  end
  seen[times % seen.size]
end

class AoCTest < Minitest::Test
  EXAMPLE = 's1,x3/4,pe/b'

  def test_solve_example
    assert_equal 'baedc', solve(EXAMPLE, programs: 'abcde')
  end

  def test_solve_input
    assert_equal 'padheomkgjfnblic', solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 'ceadb', solve2(EXAMPLE, programs: 'abcde', times: 2)
  end

  def test_solve2_input
    assert_equal 'bfcdeakhijmlgopn', solve2(read_file('input.txt'))
  end
end
