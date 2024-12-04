# frozen_string_literal: true

require 'pry'
require 'minitest/autorun'

def read_file(filename)
  # Get the directory of the currently executing script
  # Join the script directory with the filename
  # Read the content of the file
  File.read(File.join(__dir__, filename))
end

def parse_file(filename)
  read_file(filename).each_line.map do |line|
    game_id, games = line.split(':')
    cubes = games.strip.split(';').map do |sets|
      sets.split(',').map(&:split).to_h do |x|
        [x[1].to_sym, x[0].to_i]
      end
    end

    [game_id.split[1].to_i, cubes]
  end.to_h
end

def solve(filename)
  game = parse_file(filename)

  limits = { red: 12, green: 13, blue: 14 }
  possible_games = game.select do |_game_id, sets|
    sets.all? do |x|
      (x[:red] || 0) <= limits[:red] &&
        (x[:green] || 0) <= limits[:green] &&
        (x[:blue] || 0) <= limits[:blue]
    end
  end
  possible_games.sum { |game_id, _| game_id }
end

def solve2(filename)
  parse_file(filename).map do |_id, sets|
    max = { red: 0, green: 0, blue: 0 }
    sets.each do |x|
      max[:red] = [x[:red] || 0, max[:red]].max
      max[:green] = [x[:green] || 0, max[:green]].max
      max[:blue] = [x[:blue] || 0, max[:blue]].max
    end

    max
  end.sum do |set|
    set[:red] * set[:blue] * set[:green]
  end
end

class AoCTest < Minitest::Test
  def test_solve
    assert solve('test.txt') == 8
  end

  def test_solve2
    assert solve2('test.txt') == 2286
  end
end

puts 'Part1', solve('input.txt')
puts 'Part2', solve2('input.txt')
