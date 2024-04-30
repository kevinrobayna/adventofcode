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

# Adding numeric? method to String class to easily (and elegantly) know if something is a number or not
class String
  def numeric?
    !Float(self).nil?
  rescue
    false
  end
end

def solve(filename)
  columns, orders = parse_input(filename)
  orders.each do |amount, from, to|
    amount.times do
      crate = columns[from].shift
      columns[to].unshift(crate)
    end
  end
  build_solution(columns)
end

def solve2(filename)
  stacks, instructions = parse_input(filename)
  instructions.each do |quantity, from, to|
    crates = stacks[from].shift(quantity)
    crates.reverse_each do |crate|
      stacks[to].unshift(crate)
    end
  end
  build_solution(stacks)
end

def parse_input(filename)
  stacks = {}
  instructions = []
  read_file(filename).each_line do |line|
    if line.include?("move")
      amount, from, to = line.split(" ").select(&:numeric?).map(&:to_i)
      instructions << [amount, from - 1, to - 1]
    elsif line.include?("[")
      inx = 0
      elements = line.chars
      until elements.empty?
        head = elements.shift(3).join.strip
        unless head.empty?
          stacks[inx] ||= []
          stacks[inx] << head.delete("[").delete("]")
        end
        inx += 1
        elements.shift(1) # skip space between words
      end
    elsif line.include?("1")
      # We should have the same number of stacks as the number of columns
      raise if stacks.size != line.split(" ").count(&:to_i)
    end
  end
  [stacks, instructions]
end

def build_solution(columns)
  columns.sort.to_h.map { |_, value| value.first }.join
end

compare_solutions("CMZ", solve("test.txt"))
puts "Part1", solve("input.txt")

compare_solutions("MCD", solve2("test.txt"))
puts "Part2", solve2("input.txt")
