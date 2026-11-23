# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

# Scoreboard as a String of ASCII digits; generates recipes in chunks until the block returns truthy.
def scoreboard(chunk: 100_000)
  board = +'37'
  a = 0
  b = 1
  until (result = yield board)
    chunk.times do
      sa = board.getbyte(a) - 48
      sb = board.getbyte(b) - 48
      board << (sa + sb).to_s
      size = board.size
      a = (a + 1 + sa) % size
      b = (b + 1 + sb) % size
    end
  end
  result
end

def solve(input)
  n = input.to_i
  scoreboard(chunk: 1000) { |board| board[n, 10] if board.size >= n + 10 }
end

def solve2(input)
  target = input.strip
  scoreboard { |board| board.index(target) }
end

class AoCTest < Minitest::Test
  def test_solve_example
    assert_equal '5158916779', solve('9')
    assert_equal '0124515891', solve('5')
    assert_equal '9251071085', solve('18')
    assert_equal '5941429882', solve('2018')
  end

  def test_solve_input
    assert_equal '2810862211', solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 9, solve2('51589')
    assert_equal 5, solve2('01245')
    assert_equal 18, solve2('92510')
    assert_equal 2018, solve2('59414')
  end

  def test_solve2_input
    assert_equal 20_227_889, solve2(read_file('input.txt'))
  end
end
