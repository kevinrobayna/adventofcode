# frozen_string_literal: true

require_relative '../../lib/aoc'
require 'digest'

# Searches index ranges in forked worker processes (MD5 brute force is CPU bound).
def parallel_search(door_id, from, count, workers: 8)
  chunk = count / workers
  Array.new(workers) do |w|
    reader, writer = IO.pipe
    pid = fork do
      reader.close
      found = []
      ((from + (w * chunk))...(from + ((w + 1) * chunk))).each do |i|
        digest = Digest::MD5.digest("#{door_id}#{i}")
        found << Digest.hexencode(digest) if digest.getbyte(0).zero? && digest.getbyte(1).zero? && digest.getbyte(2) < 16
      end
      writer.write(found.join(','))
      writer.close
      exit!(0) # skip at_exit hooks (minitest) in the child
    end
    writer.close
    [pid, reader]
  end.flat_map do |pid, reader|
    data = reader.read
    reader.close
    Process.wait(pid)
    data.split(',')
  end
end

# Lazily computed, memoized list of hex digests with five leading zeroes, shared by both parts.
class Door
  @cache = {}

  class << self
    def [](door_id) = @cache[door_id] ||= new(door_id)
  end

  def initialize(door_id)
    @door_id = door_id
    @index = 0
    @found = []
  end

  def each
    return enum_for(:each) unless block_given?

    i = 0
    loop do
      find_next while i >= @found.size
      yield @found[i]
      i += 1
    end
  end

  private

  BATCH = 2_000_000

  def find_next
    @found.concat(parallel_search(@door_id, @index, BATCH))
    @index += BATCH
  end
end

def solve(input)
  Door[input.strip].each.first(8).map { |h| h[5] }.join
end

def solve2(input)
  password = Array.new(8)
  Door[input.strip].each do |h|
    pos = h[5].to_i(16)
    password[pos] ||= h[6] if pos < 8
    break if password.all?
  end
  password.join
end

class AoCTest < Minitest::Test
  def test_solve_example
    assert_equal '18f47a30', solve('abc')
  end

  def test_solve_input
    assert_equal 'c6697b55', solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal '05ace8e3', solve2('abc')
  end

  def test_solve2_input
    assert_equal '8c35d1ab', solve2(read_file('input.txt'))
  end
end
