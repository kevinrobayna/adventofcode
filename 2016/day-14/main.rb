# frozen_string_literal: true

# aoc: slow

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end
require 'digest'
require 'etc'

# Maps items across forked worker processes (MD5 stretching is CPU bound).
def parallel_map(items, workers: Etc.nprocessors, &block)
  items.each_slice((items.size / workers.to_f).ceil).map do |slice|
    reader, writer = IO.pipe
    pid = fork do
      reader.close
      writer.write(Marshal.dump(slice.map(&block)))
      writer.close
      exit!(0) # skip at_exit hooks (minitest) in the child
    end
    writer.close
    [pid, reader]
  end.flat_map do |pid, reader|
    data = reader.read
    reader.close
    Process.wait(pid)
    Marshal.load(data) # rubocop:disable Security/MarshalLoad
  end
end

# [first tripled char, chars repeated five times] or nil when the hash has no triple.
def hash_info(salt, index, stretch)
  h = Digest::MD5.hexdigest("#{salt}#{index}")
  stretch.times { h = Digest::MD5.hexdigest(h) }
  triple = h[/(.)\1\1/, 1]
  triple && [triple, h.scan(/(.)\1{4}/).flatten.uniq]
end

def key_index(salt, stretch: 0, batch: 8000)
  infos = []
  keys = 0
  index = 0
  loop do
    while infos.size <= index + 1000
      start = infos.size
      infos.concat(parallel_map((start...(start + batch)).to_a) { |i| hash_info(salt, i, stretch) })
    end
    triple, = infos[index]
    if triple && infos[(index + 1)..(index + 1000)].any? { |info| info&.last&.include?(triple) }
      keys += 1
      return index if keys == 64
    end
    index += 1
  end
end

def solve(input)
  key_index(input.strip)
end

def solve2(input)
  key_index(input.strip, stretch: 2016)
end

class AoCTest < Minitest::Test
  def test_solve_example
    assert_equal 22_728, solve('abc')
  end

  def test_solve_input
    assert_equal 16_106, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 22_551, solve2('abc')
  end

  def test_solve2_input
    assert_equal 22_423, solve2(read_file('input.txt'))
  end
end
