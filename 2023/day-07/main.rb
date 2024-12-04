# frozen_string_literal: true

require 'pry'
require 'colorize'

def compare_solutions(expected, actual)
  raise "Expected #{expected} but got #{actual}" unless expected == actual

  puts "Congratulations! Got expected result (#{expected})"
end

def read_file(filename)
  # Get the directory of the currently executing script
  # Join the script directory with the filename
  # Read the content of the file
  File.read(File.join(__dir__, filename))
end

TYPES = {
  [5] => 'five_of_kind',
  [4, 1] => 'four_of_kind',
  [3, 2] => 'full_house',
  [3, 1, 1] => 'three_of_kind',
  [2, 2, 1] => 'two_pair',
  [2, 1, 1, 1] => 'one_pair',
  [1, 1, 1, 1, 1] => 'high_card'
}.freeze

RANK = '23456789TJQKA'

def solve(filename)
  calculate_solution(filename, jocker: false)
end

def solve2(filename)
  calculate_solution(filename, jocker: true)
end

def calculate_solution(filename, jocker: false)
  ranks = if jocker
            "J#{RANK.delete('J')}"
          else
            RANK
          end
  read_file(filename).each_line.map do |line|
    hand, bid = line.scan(/\w+/)
    [hand, bid.to_i]
  end.sort_by do |hand, _bid|
    options = Set.new
    options << hand
    if hand.include?('J') && jocker
      hand.chars.tally.each_key do |card|
        next if card == 'J'

        options << hand.gsub('J', card)
      end
    end
    selected = options.max_by do |option|
      type = TYPES[option.chars.tally.values.sort.reverse]
      TYPES.values.reverse.index(type)
    end
    selected_type = TYPES[selected.chars.tally.values.sort.reverse]
    type_index = TYPES.values.reverse.index(selected_type)

    rank = hand.chars.map { |card, _inx| ranks.rindex(card) }
    [type_index, rank].flatten
  end
    .each_with_index.sum { |(_cards, bid), inx| (inx + 1) * bid }
end

compare_solutions(6440, solve('test.txt'))
puts 'Part1', solve('input.txt')

compare_solutions(5905, solve2('test.txt'))
puts 'Part2', solve2('input.txt')
