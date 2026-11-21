# frozen_string_literal: true

# Knot hash shared by 2017 days 10 and 14.
module KnotHash
  SUFFIX = [17, 31, 73, 47, 23].freeze

  module_function

  # Runs the knot-tying rounds and returns the resulting list of numbers.
  def sparse(lengths, size: 256, rounds: 1)
    list = (0...size).to_a
    pos = 0
    skip = 0
    rounds.times do
      lengths.each do |len|
        list.rotate!(pos)
        list[0, len] = list[0, len].reverse
        list.rotate!(-pos)
        pos = (pos + len + skip) % size
        skip += 1
      end
    end
    list
  end

  # Dense knot hash as a list of 16 bytes.
  def bytes(input)
    sparse(input.bytes + SUFFIX, rounds: 64).each_slice(16).map { |block| block.reduce(:^) }
  end

  def hex(input)
    bytes(input).map { |b| format('%02x', b) }.join
  end
end
