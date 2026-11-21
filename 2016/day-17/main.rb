# frozen_string_literal: true

require_relative '../../lib/aoc'
require 'digest'

DIRS = [['U', 0, -1], ['D', 0, 1], ['L', -1, 0], ['R', 1, 0]].freeze

# Yields every path reaching the vault (3,3), in BFS order (shortest first).
def vault_paths(passcode)
  return enum_for(:vault_paths, passcode) unless block_given?

  frontier = [['', 0, 0]]
  until frontier.empty?
    frontier = frontier.flat_map do |path, x, y|
      hash = Digest::MD5.hexdigest(passcode + path)
      DIRS.each_with_index.filter_map do |(d, dx, dy), i|
        nx = x + dx
        ny = y + dy
        next unless nx.between?(0, 3) && ny.between?(0, 3) && 'bcdef'.include?(hash[i])

        if nx == 3 && ny == 3
          yield path + d
          next
        end

        [path + d, nx, ny]
      end
    end
  end
end

def solve(input)
  vault_paths(input.strip).first
end

def solve2(input)
  vault_paths(input.strip).map(&:size).max
end

class AoCTest < Minitest::Test
  def test_solve_example
    assert_equal 'DDRRRD', solve('ihgpwlah')
    assert_equal 'DDUDRLRRUDRD', solve('kglvqrro')
    assert_equal 'DRURDRUDDLLDLUURRDULRLDUUDDDRR', solve('ulqzkmiv')
  end

  def test_solve_input
    assert_equal 'DDRRULRDRD', solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 370, solve2('ihgpwlah')
    assert_equal 492, solve2('kglvqrro')
    assert_equal 830, solve2('ulqzkmiv')
  end

  def test_solve2_input
    assert_equal 536, solve2(read_file('input.txt'))
  end
end
