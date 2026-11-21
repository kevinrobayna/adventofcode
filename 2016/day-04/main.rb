# frozen_string_literal: true

require_relative '../../lib/aoc'

Room = Struct.new(:name, :sector, :checksum) do
  def real?
    counts = name.delete('-').chars.tally
    counts.sort_by { |ch, n| [-n, ch] }.first(5).map(&:first).join == checksum
  end

  def decrypt
    name.chars.map { |ch| ch == '-' ? ' ' : (((ch.ord - 97 + sector) % 26) + 97).chr }.join
  end
end

def parse(input)
  input.scan(/^([a-z-]+)-(\d+)\[([a-z]+)\]/).map { |n, s, c| Room.new(n, s.to_i, c) }
end

def solve(input)
  parse(input).select(&:real?).sum(&:sector)
end

def solve2(input, target: 'northpole object storage')
  parse(input).select(&:real?).find { |r| r.decrypt == target }.sector
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    aaaaa-bbb-z-y-x-123[abxyz]
    a-b-c-d-e-f-g-h-987[abcde]
    not-a-real-room-404[oarel]
    totally-real-room-200[decoy]
  INPUT

  def test_solve_example
    assert_equal 1514, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 278_221, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 'very encrypted name', Room.new('qzmt-zixmtkozy-ivhz', 343, '').decrypt
  end

  def test_solve2_input
    assert_equal 267, solve2(read_file('input.txt'))
  end
end
