# frozen_string_literal: true

def compare_solutions(expected, actual)
  raise "Expected #{expected} but got #{actual}" unless expected == actual

  puts "Congratulations! Got expected result (#{expected})"
end

def read_file(filename)
  # Get the directory of the currently executing script
  # Join the script directory with the filename
  # Read the content of the file
  File.read(File.join(__dir__, filename))
end

TOTAL = 70_000_000
REQUIRED = 30_000_000

# Class to represent what a directory/file is.
# Directories contain a list of files and directories and do not have a size unless calculated.
class Node
  attr_accessor :name, :weight, :neighbors
  attr_reader :parent

  def initialize(name, weight = 0, parent = nil)
    @name = name
    @parent = parent
    @neighbors = []
    @weight = weight
  end
end

def solve(filename)
  root, directories = parse_content(filename)
  traverse_tree(root)

  directories.select { |n| n.weight < 100_000 }.sum(&:weight)
end

def solve2(filename)
  root, directories = parse_content(filename)
  traverse_tree(root)

  # Calculate the nodes that by deleting it would free enough space required to update the system.
  directories.map(&:weight).select { |d| TOTAL - root.weight + d > REQUIRED }.min
end

def parse_content(filename)
  root = Node.new('/')
  directories = [root]
  current_node = root
  reading_ls = false
  read_file(filename).each_line do |line|
    if line.include? '$'
      _, cmd, name = line.split(' ')
      case cmd
      when 'cd'
        current_node = case name
                       when '/'
                         root
                       when '..'
                         current_node.parent
                       else
                         current_node.neighbors.find { |n| n.name == name }
                       end
      when 'ls'
        reading_ls = true
        next
      end
    elsif reading_ls
      first, name = line.split(' ')
      if first == 'dir'
        n = Node.new(name, 0, current_node)
        current_node.neighbors << n
        directories << n
      else
        weight = first.to_i
        current_node.neighbors << Node.new(name, weight, current_node)
      end
    end
  end
  [root, directories]
end

def traverse_tree(root)
  queue = [root]
  while queue.any?
    current = queue.shift
    next if current.weight.positive?

    if current.neighbors.all? { |n| n.weight.positive? }
      current.weight = current.neighbors.sum(&:weight)
      next
    end

    current.neighbors.select { |n| n.weight.zero? && !n.neighbors.empty? }.each do |n|
      queue << n
    end

    queue << current

  end
end

compare_solutions(95_437, solve('test.txt'))
puts 'Part1', solve('input.txt')

compare_solutions(24_933_642, solve2('test.txt'))
puts 'Part2', solve2('input.txt')
