# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end
require_relative '../assembunny'

def clock_signal?(program, a, samples:)
  outputs = []
  Assembunny.new(program, a:).run do |bit|
    outputs << bit
    outputs.size >= samples || bit != (outputs.size - 1) % 2 ? :stop : nil
  end
  outputs == Array.new(samples) { |i| i % 2 }
end

def solve(input, samples: 32)
  (1..).find { |a| clock_signal?(input, a, samples:) }
end

class AoCTest < Minitest::Test
  # The real program without the "d = a + 7 * 362" prelude: emits the bits of a, LSB first, forever.
  EXAMPLE = <<~INPUT
    cpy a d
    cpy d a
    jnz 0 0
    cpy a b
    cpy 0 a
    cpy 2 c
    jnz b 2
    jnz 1 6
    dec b
    dec c
    jnz c -4
    inc a
    jnz 1 -7
    cpy 2 b
    jnz c 2
    jnz 1 4
    dec b
    dec c
    jnz 1 -4
    jnz 0 0
    out b
    jnz a -19
    jnz 1 -21
  INPUT

  def test_solve_example
    assert_equal 2, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 196, solve(read_file('input.txt'))
  end
end
