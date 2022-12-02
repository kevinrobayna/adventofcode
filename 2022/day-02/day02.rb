# frozen_string_literal: true

def read_file(*args)
  File.read(File.join(File.absolute_path('.'), *args))
end

ROCK = 0
PAPER = 1
SCISSORS = 2

WIN = 6
LOSE = 0
DRAW = 3

TRANSLATION = {
  "A" => 0,
  "X" => 0,

  "B" => 1,
  "Y" => 1,

  "C" => 2,
  "Z" => 2,
}

POINTS = [
  [DRAW, WIN, LOSE],
  [LOSE, DRAW, WIN],
  [WIN, LOSE, DRAW]
]

def solve(filename)

  hands = read_file(filename).split("\n").map do |line|
    opponent, yours = line.split(' ')

    opponent = TRANSLATION[opponent]
    yours = TRANSLATION[yours]

    POINTS[opponent][yours] + yours + 1
  end

  hands.sum
end

def solve2(filename)
  cheat = [
    # ROCK PAPER SCISSORS
    [SCISSORS, ROCK, PAPER], # LOSE
    [ROCK, PAPER, SCISSORS], # DRAW
    [PAPER, SCISSORS, ROCK] # WIN
  ]

  hands = read_file(filename).split("\n").map do |line|
    opponent, yours = line.split(' ')

    opponent = TRANSLATION[opponent]
    yours = TRANSLATION[yours]

    cheat_yours = cheat[yours][opponent]

    POINTS[opponent][cheat_yours] + cheat_yours + 1
  end

  hands.sum
end

puts 'Part1 Test', solve('2022/day-02/test.txt')
puts 'Part1 Real', solve('2022/day-02/input.txt')

puts 'Part2 Test', solve2('2022/day-02/test.txt')
puts 'Part2 Real', solve2('2022/day-02/input.txt')

