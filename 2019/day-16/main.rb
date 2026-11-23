# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def digits(input) = input.strip.chars.map(&:to_i)

# One FFT phase using prefix sums: output i adds blocks of length i+1 with signs +, 0, -, 0.
def phase(signal)
  prefix = [0]
  signal.each { prefix << (prefix.last + it) }
  n = signal.size
  Array.new(n) do |i|
    len = i + 1
    total = 0
    start = i
    sign = 1
    while start < n
      total += sign * (prefix[[start + len, n].min] - prefix[start])
      start += 2 * len
      sign = -sign
    end
    total.abs % 10
  end
end

def solve(input, phases: 100)
  signal = digits(input)
  phases.times { signal = phase(signal) }
  signal.first(8).join
end

# The offset lies in the second half, where each output digit is the suffix sum of the input.
def solve2(input, phases: 100)
  base = digits(input)
  offset = base.first(7).join.to_i
  total = base.size * 10_000
  raise 'offset must be in the second half' if offset < total / 2

  tail = Array.new(total - offset) { base[(offset + it) % base.size] }
  phases.times do
    sum = 0
    (tail.size - 1).downto(0) { |i| tail[i] = (sum += tail[i]) % 10 }
  end
  tail.first(8).join
end

class AoCTest < Minitest::Test
  def test_solve_example
    assert_equal '01029498', solve('12345678', phases: 4)
    assert_equal '24176176', solve('80871224585914546619083218645595')
    assert_equal '73745418', solve('19617804207202209144916044189917')
    assert_equal '52432133', solve('69317163492948606335995924319873')
  end

  def test_solve_input
    assert_equal '40921727', solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal '84462026', solve2('03036732577212944063491565474664')
    assert_equal '78725270', solve2('02935109699940807407585447034323')
    assert_equal '53553731', solve2('03081770884921959731165446850517')
  end

  def test_solve2_input
    assert_equal '89950138', solve2(read_file('input.txt'))
  end
end
