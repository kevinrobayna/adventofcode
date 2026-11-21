# frozen_string_literal: true

require_relative '../../lib/aoc'

TOTAL = 70_000_000
REQUIRED = 30_000_000

# Returns a hash of directory path => total size (including subdirectories).
def directory_sizes(input)
  sizes = Hash.new(0)
  path = []
  input.each_line do |line|
    case line.split
    in ['$', 'cd', '/'] then path = ['/']
    in ['$', 'cd', '..'] then path.pop
    in ['$', 'cd', name] then path.push(name)
    in [size, _] if size.match?(/\A\d+\z/)
      path.each_index { |i| sizes[path[0..i].join('/')] += size.to_i }
    else
      next
    end
  end
  sizes
end

def solve(input)
  directory_sizes(input).values.select { |s| s <= 100_000 }.sum
end

def solve2(input)
  sizes = directory_sizes(input)
  needed = REQUIRED - (TOTAL - sizes['/'])
  sizes.values.select { |s| s >= needed }.min
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    $ cd /
    $ ls
    dir a
    14848514 b.txt
    8504156 c.dat
    dir d
    $ cd a
    $ ls
    dir e
    29116 f
    2557 g
    62596 h.lst
    $ cd e
    $ ls
    584 i
    $ cd ..
    $ cd ..
    $ cd d
    $ ls
    4060174 j
    8033020 d.log
    5626152 d.ext
    7214296 k
  INPUT

  def test_solve_example
    assert_equal 95_437, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 1_432_936, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 24_933_642, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 272_298, solve2(read_file('input.txt'))
  end
end
