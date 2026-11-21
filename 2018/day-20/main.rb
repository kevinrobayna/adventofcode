# frozen_string_literal: true

require_relative '../../lib/aoc'

MOVES = { 'N' => [0, -1], 'S' => [0, 1], 'E' => [1, 0], 'W' => [-1, 0] }.freeze

# Builds the door graph by walking the regex, then BFS distances from the start room.
def room_distances(regex)
  doors = Hash.new { |h, k| h[k] = Set.new }
  current = Set[[0, 0]]
  stack = [] # [group start positions, accumulated ends]
  regex.strip.delete('$^').each_char do |c|
    case c
    when '('
      stack << [current, Set.new]
    when '|'
      stack.last[1].merge(current)
      current = stack.last[0]
    when ')'
      ends = stack.pop.last
      current = ends.merge(current)
    else
      dx, dy = MOVES.fetch(c)
      current = current.to_set do |x, y|
        nxt = [x + dx, y + dy]
        doors[[x, y]] << nxt
        doors[nxt] << [x, y]
        nxt
      end
    end
  end
  dist = { [0, 0] => 0 }
  queue = [[0, 0]]
  until queue.empty?
    room = queue.shift
    doors[room].each do |n|
      next if dist.key?(n)

      dist[n] = dist[room] + 1
      queue << n
    end
  end
  dist
end

def solve(input)
  room_distances(input).values.max
end

def solve2(input, min_doors: 1000)
  room_distances(input).values.count { |d| d >= min_doors }
end

class AoCTest < Minitest::Test
  def test_solve_example
    assert_equal 3, solve('^WNE$')
    assert_equal 10, solve('^ENWWW(NEEE|SSE(EE|N))$')
    assert_equal 18, solve('^ENNWSWW(NEWS|)SSSEEN(WNSE|)EE(SWEN|)NNN$')
    assert_equal 23, solve('^ESSWWN(E|NNENN(EESS(WNSE|)SSS|WWWSSSSE(SW|NNNE)))$')
    assert_equal 31, solve('^WSSEESWWWNW(S|NENNEEEENN(ESSSSW(NWSW|SSEN)|WSWWN(E|WWS(E|SS))))$')
  end

  def test_solve_input
    assert_equal 3872, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 4, solve2('^ENWWW(NEEE|SSE(EE|N))$', min_doors: 9)
  end

  def test_solve2_input
    assert_equal 8600, solve2(read_file('input.txt'))
  end
end
