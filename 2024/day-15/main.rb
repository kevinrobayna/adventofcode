# frozen_string_literal: true

require_relative '../../lib/aoc'

MOVES = { '^' => [-1, 0], 'v' => [1, 0], '<' => [0, -1], '>' => [0, 1] }.freeze
WIDEN = { '#' => '##', 'O' => '[]', '.' => '..', '@' => '@.' }.freeze

# Moves the robot; boxes ('O' or '[' + ']') are pushed as a group if nothing blocks them.
def simulate(map_text, moves_text)
  grid = map_text.lines.map { _1.chomp.chars }
  r = grid.index { _1.include?('@') }
  c = grid[r].index('@')
  moves_text.delete("\n").each_char do |m|
    dr, dc = MOVES.fetch(m)
    to_move = [[r, c]]
    queue = [[r, c]]
    blocked = false
    until queue.empty? || blocked
      cr, cc = queue.shift
      nr = cr + dr
      nc = cc + dc
      cell = grid[nr][nc]
      blocked = true if cell == '#'
      pushed = case cell
               when 'O' then [[nr, nc]]
               when '[' then [[nr, nc], [nr, nc + 1]]
               when ']' then [[nr, nc], [nr, nc - 1]]
               else []
               end
      (pushed - to_move).each do |pos|
        to_move << pos
        queue << pos
      end
    end
    next if blocked

    saved = to_move.map { |pr, pc| [pr, pc, grid[pr][pc]] }
    to_move.each { |pr, pc| grid[pr][pc] = '.' }
    saved.each { |pr, pc, ch| grid[pr + dr][pc + dc] = ch }
    r += dr
    c += dc
  end
  grid
end

def gps(grid)
  grid.each_with_index.sum do |row, r|
    row.each_with_index.sum { |ch, c| %w[O \[].include?(ch) ? (100 * r) + c : 0 }
  end
end

def solve(input)
  gps(simulate(*input.split("\n\n")))
end

def solve2(input)
  map_text, moves_text = input.split("\n\n")
  gps(simulate(map_text.gsub(/[#O.@]/, WIDEN), moves_text))
end

class AoCTest < Minitest::Test
  SMALL = <<~INPUT
    ########
    #..O.O.#
    ##@.O..#
    #...O..#
    #.#.O..#
    #...O..#
    #......#
    ########

    <^^>>>vv<v>>v<<
  INPUT

  EXAMPLE = <<~INPUT
    ##########
    #..O..O.O#
    #......O.#
    #.OO..O.O#
    #..O@..O.#
    #O#..O...#
    #O..O..O.#
    #.OO.O.OO#
    #....O...#
    ##########

    <vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
    vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
    ><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
    <<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
    ^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
    ^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
    >^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
    <><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
    ^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
    v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
  INPUT

  def test_solve_example
    assert_equal 2028, solve(SMALL)
    assert_equal 10_092, solve(EXAMPLE)
  end

  def test_solve2_example
    assert_equal 618, solve2(<<~INPUT)
      #######
      #...#.#
      #.....#
      #..OO@#
      #..O..#
      #.....#
      #######

      <vv<<^^<<^^
    INPUT
    assert_equal 9021, solve2(EXAMPLE)
  end

  def test_solve_input
    assert_equal 1_486_930, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 1_492_011, solve2(read_file('input.txt'))
  end
end
