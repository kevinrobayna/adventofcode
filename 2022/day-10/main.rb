# frozen_string_literal: true

require 'matrix'

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

CYCLES = {
  'noop' => 1,
  'addx' => 2
}.freeze

class Instruction
  attr_reader :name, :value

  def initialize(name, value = 0)
    @name = name
    @value = value
    @remaining_cycles = CYCLES[name]
    @running = false
  end

  def running?
    @running
  end

  def run
    @running = true
    @remaining_cycles -= 1
  end

  def finished?
    @remaining_cycles.zero?
  end

  def noop?
    @name == 'noop'
  end

  def to_s
    if noop?
      @name
    else
      "#{@name} #{@value}"
    end
  end
end

def solve(filename)
  clock_values = { 1 => 1 }
  instructions = instructions(filename)

  clock = 1
  current_instruction = instructions.shift
  while clock <= 220 && instructions.size.positive?
    if current_instruction.finished?
      clock_values[clock] = clock_values[clock - 1] + current_instruction.value
      current_instruction = instructions.shift
    end
    current_instruction.run

    clock += 1
    clock_values[clock] = clock_values[clock - 1]
  end

  expected_clock_values = [20, 60, 100, 140, 180, 220]
  expected_clock_values.map { clock_values[_1] * _1 }.sum
end

class Sprite
  def initialize
    sprite = Array.new(40, '.')
    sprite[0] = '#'
    sprite[1] = '#'
    sprite[2] = '#'
    @sprite = sprite
  end

  def to_s
    @sprite.join
  end

  def [](index)
    @sprite[index]
  end

  def registry
    @sprite.find_index('#')
  end

  def shift(chars)
    if chars.positive?
      chars.times do
        char = @sprite.pop
        @sprite.unshift(char)
      end
    else
      chars.abs.times do
        char = @sprite.shift
        @sprite.push(char)
      end
    end
    raise unless @sprite.size == 40

    count = @sprite.select { _1 == '#' }.size
    raise "Expected 3# but got #{count} after moving N #{chars}" unless count == 3

    chars
  end
end

def solve2(filename)
  instructions = instructions(filename)
  screen = Matrix.build(6, 40) { '.' }
  sprite = Sprite.new

  puts "Sprite position: #{sprite}"

  current_instruction = nil

  screen.each_with_index do |_, row, col|
    clock = row * 40 + col + 1
    if current_instruction.nil? || current_instruction.finished?
      current_instruction = instructions.shift
      puts "Start cycle   #{clock}: begin executing #{current_instruction}"
    end

    current_instruction.run

    puts "During cycle  #{clock}: CRT draws pixel in position #{col}"
    screen[row, col] = sprite[col]

    puts "Current CRT row: #{screen.row(row).to_a.join}"
    if current_instruction.finished?
      if current_instruction.noop?
        puts "End of cycle  #{clock}: finish executing #{current_instruction}"
      else
        sprite.shift(current_instruction.value)
        puts "End of cycle  #{clock}: finish executing #{current_instruction} (Register X is now #{sprite.registry})"
      end
    end
    puts "Sprite position: #{sprite}" unless current_instruction.noop?
    puts
  end
  screen.to_a.map(&:join).join("\n")
end

def instructions(filename)
  read_file(filename).each_line.map do |line|
    name, value = line.split(' ')
    if value
      Instruction.new(name, value.to_i)
    else
      Instruction.new(name)
    end
  end
end

compare_solutions(13_140, solve('2022/day-10/test.txt'))
puts 'Part1', solve('2022/day-10/input.txt')

expected = "##..##..##..##..##..##..##..##..##..##..
###...###...###...###...###...###...###.
####....####....####....####....####....
#####.....#####.....#####.....#####.....
######......######......######......####
#######.......#######.......#######....."
compare_solutions(expected, solve2('2022/day-10/test.txt'))
puts 'Part2', solve2('2022/day-10/input.txt')
