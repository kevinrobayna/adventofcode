# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

require 'digest'
require 'etc'

# Runs the block on each item in its own forked process; results must be integers or nil.
def parallel_map(items)
  items.map do |item|
    reader, writer = IO.pipe
    pid = fork do
      reader.close
      writer.write(yield(item).to_s)
      exit!(0) # skip at_exit hooks (minitest) in the child
    end
    writer.close
    [pid, reader]
  end.map do |pid, reader|
    out = reader.read
    reader.close
    Process.wait(pid)
    out.empty? ? nil : out.to_i
  end
end

# Finds the lowest n >= start whose MD5("#{key}#{n}") hex digest starts with `prefix`.
# Searches `workers` consecutive chunks per round; the lowest hit in a round is the answer,
# since every lower n was covered by this or an earlier round.
def mine(key, prefix, start: 1, workers: Etc.nprocessors, chunk: 200_000)
  key = key.strip
  from = start
  loop do
    ranges = Array.new(workers) { |w| (from + (w * chunk))...(from + ((w + 1) * chunk)) }
    found = parallel_map(ranges) do |range|
      md5 = Digest::MD5.new
      range.find { |n| md5.reset.update(key).update(n.to_s).hexdigest.start_with?(prefix) }
    end.compact.min
    return found if found

    from += workers * chunk
  end
end

def solve(input)
  mine(input, '00000')
end

# Every 6-zero hash is also a 5-zero hash, so the search can resume from part 1.
def solve2(input)
  mine(input, '000000', start: solve(input))
end

class AoCTest < Minitest::Test
  def test_solve_example
    assert_equal 609_043, solve('abcdef')
  end

  def test_mine_returns_lowest_match_across_rounds_and_workers
    assert_equal 609_043, mine('abcdef', '00000', workers: 4, chunk: 5_000)
    assert_equal 609_043, mine('abcdef', '00000', start: 609_043, workers: 3, chunk: 7)
  end

  def test_solve_input
    assert_equal 282_749, solve(read_file('input.txt'))
  end

  def test_solve2_input
    assert_equal 9_962_624, solve2(read_file('input.txt'))
  end
end
