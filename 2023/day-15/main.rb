# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def hash_of(str)
  str.each_byte.reduce(0) { |acc, b| ((acc + b) * 17) % 256 }
end

def solve(input)
  input.strip.split(',').sum { hash_of(it) }
end

def solve2(input)
  boxes = Array.new(256) { {} }
  input.strip.split(',').each do |step|
    label, focal = step.split(/[=-]/)
    box = boxes[hash_of(label)]
    if focal
      box[label] = focal.to_i # Ruby hashes keep insertion order, and updating keeps the slot
    else
      box.delete(label)
    end
  end
  boxes.each_with_index.sum do |box, i|
    box.values.each_with_index.sum { |focal, slot| (i + 1) * (slot + 1) * focal }
  end
end

class AoCTest < Minitest::Test
  EXAMPLE = "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7\n"

  def test_hash
    assert_equal 52, hash_of('HASH')
  end

  def test_solve_example
    assert_equal 1320, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 506_437, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 145, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 288_521, solve2(read_file('input.txt'))
  end
end
