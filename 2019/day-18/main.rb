# frozen_string_literal: true

require_relative '../../lib/aoc'

# BFS from a point to every reachable key: {key => [distance, doors_mask]} (other keys en route count as doors).
def reach(rows, start)
  seen = { start => true }
  queue = [[start, 0, 0]]
  found = {}
  until queue.empty?
    (x, y), dist, needs = queue.shift
    [[1, 0], [-1, 0], [0, 1], [0, -1]].each do |dx, dy|
      pos = [x + dx, y + dy]
      c = rows[pos[1]][pos[0]]
      next if c == '#' || seen[pos]

      seen[pos] = true
      need = needs
      need |= 1 << (c.ord - 65) if c.match?(/[A-Z]/)
      if c.match?(/[a-z]/)
        found[c] = [dist + 1, need]
        need |= 1 << (c.ord - 97)
      end
      queue << [pos, dist + 1, need]
    end
  end
  found
end

# Dijkstra over (robot locations, collected keys) using a bucket queue.
def collect_keys(rows)
  points = {}
  rows.each_with_index do |row, y|
    row.chars.each_with_index { |c, x| points[c == '@' ? points.size.to_s : c] = [x, y] if c.match?(/[a-z@]/) }
  end
  graph = points.transform_values { reach(rows, it) }
  all = points.keys.grep(/[a-z]/).sum { 1 << (it.ord - 97) }
  start = [points.keys.grep(/\d/).sort, 0]
  best = { start => 0 }
  buckets = [[start]]
  buckets.each_with_index do |bucket, dist|
    bucket&.each do |robots, keys|
      next if best[[robots, keys]] < dist
      return dist if keys == all

      robots.each_with_index do |at, i|
        graph[at].each do |key, (d, needs)|
          bit = 1 << (key.ord - 97)
          next if keys & bit != 0 || needs & ~keys != 0

          state = [robots.dup.tap { it[i] = key }, keys | bit]
          next if best.fetch(state, Float::INFINITY) <= dist + d

          best[state] = dist + d
          (buckets[dist + d] ||= []) << state
        end
      end
    end
  end
  nil
end

def solve(input)
  collect_keys(input.split("\n"))
end

def split_vault(rows)
  return rows unless rows.join.count('@') == 1

  rows = rows.map(&:dup)
  y = rows.index { it.include?('@') }
  x = rows[y].index('@')
  ['@#@', '###', '@#@'].each_with_index { |patch, dy| rows[y - 1 + dy][x - 1, 3] = patch }
  rows
end

def solve2(input)
  collect_keys(split_vault(input.split("\n")))
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~'INPUT'
    #########
    #b.A.@.a#
    #########
  INPUT

  EXAMPLE7 = <<~'INPUT'
    ########################
    #f.D.E.e.C.b.A.@.a.B.c.#
    ######################.#
    #d.....................#
    ########################
  INPUT

  EXAMPLE17 = <<~'INPUT'
    ########################
    #...............b.C.D.f#
    #.######################
    #.....@.a.B.c.d.A.e.F.g#
    ########################
  INPUT

  EXAMPLE18 = <<~'INPUT'
    #################
    #i.G..c...e..H.p#
    ########.########
    #j.A..b...f..D.o#
    ########@########
    #k.E..a...g..B.n#
    ########.########
    #l.F..d...h..C.m#
    #################
  INPUT

  EXAMPLE19 = <<~'INPUT'
    ########################
    #@..............ac.GI.b#
    ###d#e#f################
    ###A#B#C################
    ###g#h#i################
    ########################
  INPUT

  def test_solve_example
    assert_equal 8, solve(EXAMPLE)
    assert_equal 86, solve(EXAMPLE7)
    assert_equal 132, solve(EXAMPLE17)
    assert_equal 136, solve(EXAMPLE18)
    assert_equal 81, solve(EXAMPLE19)
  end

  def test_solve2_example
    assert_equal 8, solve2(<<~'INPUT')
      #######
      #a.#Cd#
      ##...##
      ##.@.##
      ##...##
      #cB#Ab#
      #######
    INPUT
    assert_equal 24, solve2(<<~'INPUT')
      ###############
      #d.ABC.#.....a#
      ######@#@######
      ###############
      ######@#@######
      #b.....#.....c#
      ###############
    INPUT
    assert_equal 32, solve2(<<~'INPUT')
      #############
      #DcBa.#.GhKl#
      #.###@#@#I###
      #e#d#####j#k#
      ###C#@#@###J#
      #fEbA.#.FgHi#
      #############
    INPUT
    assert_equal 72, solve2(<<~'INPUT')
      #############
      #g#f.D#..h#l#
      #F###e#E###.#
      #dCba@#@BcIJ#
      #############
      #nK.L@#@G...#
      #M###N#H###.#
      #o#m..#i#jk.#
      #############
    INPUT
  end

  def test_solve_input
    assert_equal 4770, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 1578, solve2(read_file('input.txt'))
  end
end
