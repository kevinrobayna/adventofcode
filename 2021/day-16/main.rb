# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

# Parses BITS packets from a bit string into nested hashes.
class PacketParser
  def initialize(hex)
    @bits = hex.strip.chars.map { |h| h.to_i(16).to_s(2).rjust(4, '0') }.join
    @pos = 0
  end

  def parse
    version = read(3)
    type = read(3)
    return { version: version, type: type, value: literal } if type == 4

    { version: version, type: type, children: sub_packets }
  end

  private

  def read(count)
    value = @bits[@pos, count].to_i(2)
    @pos += count
    value
  end

  def literal
    value = 0
    loop do
      more = read(1)
      value = (value << 4) | read(4)
      return value if more.zero?
    end
  end

  def sub_packets
    if read(1).zero?
      finish = read(15) + @pos
      children = []
      children << parse while @pos < finish
      children
    else
      Array.new(read(11)) { parse }
    end
  end
end

def version_sum(packet)
  packet[:version] + (packet[:children] || []).sum { |c| version_sum(c) }
end

def evaluate(packet)
  return packet[:value] if packet[:type] == 4

  values = packet[:children].map { |c| evaluate(c) }
  case packet[:type]
  when 0 then values.sum
  when 1 then values.reduce(:*)
  when 2 then values.min
  when 3 then values.max
  when 5 then values[0] > values[1] ? 1 : 0
  when 6 then values[0] < values[1] ? 1 : 0
  when 7 then values[0] == values[1] ? 1 : 0
  end
end

def solve(input)
  version_sum(PacketParser.new(input).parse)
end

def solve2(input)
  evaluate(PacketParser.new(input).parse)
end

class AoCTest < Minitest::Test
  def test_solve_example
    assert_equal 6, solve('D2FE28')
    assert_equal 16, solve('8A004A801A8002F478')
    assert_equal 12, solve('620080001611562C8802118E34')
    assert_equal 23, solve('C0015000016115A2E0802F182340')
    assert_equal 31, solve('A0016C880162017C3686B18A3D4780')
  end

  def test_solve_input
    assert_equal 999, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 2021, solve2('D2FE28')
    assert_equal 3, solve2('C200B40A82')
    assert_equal 54, solve2('04005AC33890')
    assert_equal 7, solve2('880086C3E88112')
    assert_equal 9, solve2('CE00C43D881120')
    assert_equal 1, solve2('D8005AC2A8F0')
    assert_equal 0, solve2('F600BC2D8F')
    assert_equal 0, solve2('9C005AC2F8F0')
    assert_equal 1, solve2('9C0141080250320F1802104A08')
  end

  def test_solve2_input
    assert_equal 3_408_662_834_145, solve2(read_file('input.txt'))
  end
end
