# frozen_string_literal: true

require_relative '../../lib/aoc'
require_relative '../intcode'

MOVES = { 1 => [0, -1], 2 => [0, 1], 3 => [-1, 0], 4 => [1, 0] }.freeze
BACK = { 1 => 2, 2 => 1, 3 => 4, 4 => 3 }.freeze

# Maps the area with a depth-first walk of the droid: {pos => '.', '#' or 'O'}.
def explore(vm)
  map = { [0, 0] => '.' }
  walk = lambda do |pos|
    MOVES.each do |cmd, (dx, dy)|
      nxt = [pos[0] + dx, pos[1] + dy]
      next if map.key?(nxt)

      status = vm.run(cmd).first
      map[nxt] = '#.O'[status]
      next if status.zero?

      walk.call(nxt)
      vm.run(BACK[cmd])
    end
  end
  walk.call([0, 0])
  map
end

def parse_map(text)
  text.lines.each_with_index.flat_map do |line, y|
    line.chomp.chars.each_with_index.map { |c, x| [[x, y], c] }
  end.to_h
end

def distances(map, start)
  dist = { start => 0 }
  queue = [start]
  until queue.empty?
    pos = queue.shift
    MOVES.each_value do |dx, dy|
      nxt = [pos[0] + dx, pos[1] + dy]
      next if dist.key?(nxt) || !%w[. O D].include?(map[nxt])

      dist[nxt] = dist[pos] + 1
      queue << nxt
    end
  end
  dist
end

def oxygen(map) = map.key('O')

def solve(input)
  map = explore(Intcode.new(input))
  distances(map, [0, 0])[oxygen(map)]
end

def fill_time(map) = distances(map, oxygen(map)).values.max

def solve2(input)
  fill_time(explore(Intcode.new(input)))
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    .##...
    #..##.
    #.#..#
    #.O.#.
    .###..
  INPUT

  def test_solve_example
    map = parse_map(" ##\n#D.#\n#.O#\n ##\n")

    assert_equal 2, distances(map, [1, 1])[oxygen(map)]
  end

  def test_solve_input
    assert_equal 216, solve(read_file('input.txt'))
  end

  def test_solve2_example
    map = parse_map(EXAMPLE)
    [[0, 0], [3, 0], [4, 0], [5, 0], [5, 1], [5, 3], [4, 4], [5, 4], [0, 4]].each { map[it] = ' ' }

    assert_equal 4, fill_time(map)
  end

  def test_solve2_input
    assert_equal 326, solve2(read_file('input.txt'))
  end
end
