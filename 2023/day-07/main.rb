# frozen_string_literal: true

require 'pry'
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

def solve(filename)
  read_file(filename).each_line.map do |line|
    cards, bid = line.scan(/\w+/)
    [cards, bid.to_i]
  end.sort_by do |cards, _bid|
    ranks = '23456789TJQKA'
    config = cards.split('').tally
    type = TYPES[config.values.sort.reverse]
    type_index = TYPES.values.reverse.index(type)
    rank = cards.split('').map { |card, _inx| ranks.rindex(card) }
    order_by = [type_index, rank].flatten
    # puts "#Cards=#{cards}, type=#{type}, order_by=#{order_by}"
    order_by
  end.each_with_index.sum do |((cards, bid), inx)|
    puts "Cards #{cards} bid: #{bid} on rank: ##{inx + 1}"
    (inx + 1) * bid
  end
end

def solve2(filename)
  read_file(filename)
  0
end

compare_solutions(6440, solve('test.txt'))
puts 'Part1', solve('input.txt')

compare_solutions(0, solve2('test.txt'))
puts 'Part2', solve2('input.txt')
