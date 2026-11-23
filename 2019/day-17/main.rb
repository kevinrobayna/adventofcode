# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end
require_relative '../intcode'

def camera(input) = Intcode.new(input).run.pack('c*')

def grid(view) = view.split("\n").reject(&:empty?)

def scaffold?(rows, x, y) = y >= 0 && x >= 0 && y < rows.size && '#^<>v'.include?(rows[y][x] || '.')

def alignment(view)
  rows = grid(view)
  rows.each_index.sum do |y|
    rows[y].size.times.sum do |x|
      cross = [[0, 0], [1, 0], [-1, 0], [0, 1], [0, -1]].all? { |dx, dy| scaffold?(rows, x + dx, y + dy) }
      cross ? x * y : 0
    end
  end
end

def solve(input)
  alignment(camera(input))
end

# Walks the scaffold going straight as long as possible and returns tokens like "R,8".
def path(view)
  rows = grid(view)
  y = rows.index { it =~ /[\^<>v]/ }
  x = rows[y] =~ /[\^<>v]/
  dx, dy = { '^' => [0, -1], 'v' => [0, 1], '<' => [-1, 0], '>' => [1, 0] }[rows[y][x]]
  tokens = []
  loop do
    turn, (dx, dy) = [['L', [dy, -dx]], ['R', [-dy, dx]]].find { |_, (ax, ay)| scaffold?(rows, x + ax, y + ay) }
    return tokens unless turn

    steps = 0
    while scaffold?(rows, x + dx, y + dy)
      x += dx
      y += dy
      steps += 1
    end
    tokens << "#{turn},#{steps}"
  end
end

# Splits tokens into a main routine plus three functions A, B, C (each at most 20 chars).
def compress(tokens, funcs = [], main = [])
  return if main.size > 10
  return [main, funcs] if tokens.empty?

  funcs.each_with_index do |f, i|
    next unless tokens.first(f.size) == f

    found = compress(tokens.drop(f.size), funcs, main + ['ABC'[i]])
    return found if found
  end
  return if funcs.size == 3

  (1..tokens.size).each do |len|
    candidate = tokens.first(len)
    break if candidate.join(',').size > 20

    found = compress(tokens.drop(len), funcs + [candidate], main + ['ABC'[funcs.size]])
    return found if found
  end
  nil
end

def movement_routine(view)
  main, funcs = compress(path(view))
  [main.join(','), *funcs.map { it.join(',') }, *Array.new(3 - funcs.size, 'L,1')]
end

def solve2(input)
  routine = movement_routine(camera(input))
  vm = Intcode.new(input)
  vm.mem[0] = 2
  vm.run_ascii(*routine, 'n').last
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    ..#..........
    ..#..........
    #######...###
    #.#...#...#.#
    #############
    ..#...#...#..
    ..#####...^..
  INPUT

  EXAMPLE2 = <<~INPUT
    #######...#####
    #.....#...#...#
    #.....#...#...#
    ......#...#...#
    ......#...###.#
    ......#.....#.#
    ^########...#.#
    ......#.#...#.#
    ......#########
    ........#...#..
    ....#########..
    ....#...#......
    ....#...#......
    ....#...#......
    ....#####......
  INPUT

  def test_solve_example
    assert_equal 76, alignment(EXAMPLE)
  end

  def test_solve_input
    assert_equal 3660, solve(read_file('input.txt'))
  end

  def test_solve2_example
    tokens = path(EXAMPLE2)

    assert_equal 'R,8,R,8,R,4,R,4,R,8,L,6,L,2,R,4,R,4,R,8,R,8,R,8,L,6,L,2', tokens.join(',')
    main, *funcs = movement_routine(EXAMPLE2)
    expanded = main.split(',').flat_map { funcs['ABC'.index(it)].split(',') }

    assert_equal tokens.join(',').split(','), expanded
  end

  def test_solve2_input
    assert_equal 962_913, solve2(read_file('input.txt'))
  end
end
