# frozen_string_literal: true

require_relative '../../lib/aoc'
require_relative '../intcode'

DANGEROUS = ['infinite loop', 'giant electromagnet', 'molten lava', 'escape pod', 'photons'].freeze
OPPOSITE = { 'north' => 'south', 'south' => 'north', 'east' => 'west', 'west' => 'east' }.freeze

Room = Struct.new(:name, :doors, :items)

def parse_room(text)
  name = text[/== (.+) ==/, 1]
  list = ->(header) { text[/#{header}\n((?:- .+\n)+)/, 1].to_s.scan(/- (.+)/).flatten }
  Room.new(name, list.call('Doors here lead:'), list.call('Items here:'))
end

# Drives the text adventure through an Intcode VM.
class Droid
  def initialize(program) = @vm = Intcode.new(program)

  def command(text = nil)
    (text ? @vm.run_ascii(text) : @vm.run).pack('c*')
  end
end

# Explores every room depth-first, taking every safe item. Returns the path to the security checkpoint
# and the direction from there onto the pressure-sensitive floor.
def explore(droid, room, path = [], seen = {}, found = {})
  seen[room.name] = true
  (room.items - DANGEROUS).each { droid.command("take #{it}") }
  room.doors.each do |dir|
    text = droid.command(dir)
    nxt = parse_room(text)
    if nxt.name == 'Pressure-Sensitive Floor'
      found[:checkpoint] = path.dup
      found[:floor] = dir
      next
    end
    if seen[nxt.name]
      droid.command(OPPOSITE[dir])
      next
    end
    explore(droid, nxt, path + [dir], seen, found)
    droid.command(OPPOSITE[dir])
  end
  found
end

# Tries item combinations in Gray-code order (one take/drop per attempt) until the floor lets us pass.
def crack(droid, items, floor)
  items.each { droid.command("drop #{it}") }
  held = 0
  (1...(1 << items.size)).each do |n|
    gray = n ^ (n >> 1)
    bit = (gray ^ held).bit_length - 1
    droid.command("#{gray[bit] == 1 ? 'take' : 'drop'} #{items[bit]}")
    held = gray
    code = droid.command(floor)[/typing (\d+) on the keypad/, 1]
    return code.to_i if code
  end
  nil
end

def solve(input)
  droid = Droid.new(input)
  found = explore(droid, parse_room(droid.command))
  found[:checkpoint].each { droid.command(it) }
  items = droid.command('inv').scan(/- (.+)/).flatten
  crack(droid, items, found[:floor])
end

class AoCTest < Minitest::Test
  ROOM = <<~TEXT
    == Hot Chocolate Fountain ==
    Somehow, it's still working.

    Doors here lead:
    - east
    - south

    Items here:
    - wreath

    Command?
  TEXT

  def test_solve_example
    room = parse_room(ROOM)

    assert_equal 'Hot Chocolate Fountain', room.name
    assert_equal %w[east south], room.doors
    assert_equal ['wreath'], room.items
  end

  def test_solve_input
    assert_equal 2_415_919_488, solve(read_file('input.txt'))
  end
end
