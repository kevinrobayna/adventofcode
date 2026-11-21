# frozen_string_literal: true

require_relative '../../lib/aoc'

class Valley
  attr_reader :start, :goal

  def initialize(input)
    lines = input.split("\n")
    @cells = lines[1..-2].map { |line| line[1..-2] }
    @height = @cells.size
    @width = @cells[0].size
    @start = [-1, lines[0].index('.') - 1]
    @goal = [@height, lines[-1].index('.') - 1]
  end

  # Blizzards wrap around, so at minute t a cell holds a blizzard if one started t cells "behind" it.
  def open?(row, col, time)
    return true if [row, col] == @start || [row, col] == @goal
    return false unless row.between?(0, @height - 1) && col.between?(0, @width - 1)

    @cells[row][(col - time) % @width] != '>' &&
      @cells[row][(col + time) % @width] != '<' &&
      @cells[(row - time) % @height][col] != 'v' &&
      @cells[(row + time) % @height][col] != '^'
  end

  # Breadth-first over minutes, tracking every reachable position.
  def travel(from, to, time)
    frontier = Set[from]
    until frontier.include?(to)
      time += 1
      frontier = frontier.each_with_object(Set.new) do |(r, c), nxt|
        [[r, c], [r + 1, c], [r - 1, c], [r, c + 1], [r, c - 1]].each do |pos|
          nxt << pos if open?(*pos, time)
        end
      end
    end
    time
  end
end

def solve(input)
  valley = Valley.new(input)
  valley.travel(valley.start, valley.goal, 0)
end

def solve2(input)
  valley = Valley.new(input)
  there = valley.travel(valley.start, valley.goal, 0)
  back = valley.travel(valley.goal, valley.start, there)
  valley.travel(valley.start, valley.goal, back)
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    #.######
    #>>.<^<#
    #.<..<<#
    #>v.><>#
    #<^v^^>#
    ######.#
  INPUT

  def test_solve_example
    assert_equal 18, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 311, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 54, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 869, solve2(read_file('input.txt'))
  end
end
