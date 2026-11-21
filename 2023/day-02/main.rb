# frozen_string_literal: true

require_relative '../../lib/aoc'

def parse(input)
  input.each_line.to_h do |line|
    game_id, games = line.split(':')
    cubes = games.strip.split(';').map do |sets|
      sets.split(',').map(&:split).to_h { |x| [x[1].to_sym, x[0].to_i] }
    end

    [game_id.split[1].to_i, cubes]
  end
end

def solve(input)
  limits = { red: 12, green: 13, blue: 14 }
  possible_games = parse(input).select do |_game_id, sets|
    sets.all? { |x| limits.all? { |color, limit| x.fetch(color, 0) <= limit } }
  end
  possible_games.keys.sum
end

def solve2(input)
  parse(input).values.sum do |sets|
    %i[red green blue].map { |color| sets.map { |x| x.fetch(color, 0) }.max }.reduce(:*)
  end
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
  INPUT

  def test_solve_example
    assert_equal 8, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 2545, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 2286, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 78_111, solve2(read_file('input.txt'))
  end
end
