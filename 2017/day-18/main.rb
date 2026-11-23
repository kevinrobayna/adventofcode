# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

def parse_program(input)
  input.lines.map(&:split).reject(&:empty?)
end

# One duet program; `step` runs until it blocks on an empty inbox or terminates.
class Duet
  attr_reader :outbox, :sent

  def initialize(program, id, inbox)
    @program = program
    @regs = Hash.new(0)
    @regs['p'] = id
    @inbox = inbox
    @outbox = []
    @pc = 0
    @sent = 0
  end

  def val(x)
    /-?\d/.match?(x) ? x.to_i : @regs[x]
  end

  def terminated?
    @pc.negative? || @pc >= @program.size
  end

  # Runs until blocked; returns true if any instruction executed.
  def run
    progressed = false
    until terminated?
      op, x, y = @program[@pc]
      case op
      when 'snd'
        @outbox << val(x)
        @sent += 1
      when 'set' then @regs[x] = val(y)
      when 'add' then @regs[x] += val(y)
      when 'mul' then @regs[x] *= val(y)
      when 'mod' then @regs[x] %= val(y)
      when 'rcv'
        return progressed if @inbox.empty?

        @regs[x] = @inbox.shift
      when 'jgz'
        if val(x).positive?
          @pc += val(y)
          progressed = true
          next
        end
      end
      @pc += 1
      progressed = true
    end
    progressed
  end
end

def solve(input)
  program = parse_program(input)
  regs = Hash.new(0)
  val = ->(x) { /-?\d/.match?(x) ? x.to_i : regs[x] }
  pc = 0
  last_sound = nil
  loop do
    op, x, y = program[pc]
    case op
    when 'snd' then last_sound = val[x]
    when 'set' then regs[x] = val[y]
    when 'add' then regs[x] += val[y]
    when 'mul' then regs[x] *= val[y]
    when 'mod' then regs[x] %= val[y]
    when 'rcv' then return last_sound unless val[x].zero?
    when 'jgz' then pc += val[y] - 1 if val[x].positive?
    end
    pc += 1
  end
end

def solve2(input)
  program = parse_program(input)
  queue0 = []
  queue1 = []
  p0 = Duet.new(program, 0, queue0)
  p1 = Duet.new(program, 1, queue1)
  loop do
    moved0 = p0.run
    queue1.concat(p0.outbox.slice!(0..))
    moved1 = p1.run
    queue0.concat(p1.outbox.slice!(0..))
    break unless moved0 || moved1
  end
  p1.sent
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    set a 1
    add a 2
    mul a a
    mod a 5
    snd a
    set a 0
    rcv a
    jgz a -1
    set a 1
    jgz a -2
  INPUT

  EXAMPLE2 = <<~INPUT
    snd 1
    snd 2
    snd p
    rcv a
    rcv b
    rcv c
    rcv d
  INPUT

  def test_solve_example
    assert_equal 4, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 2_951, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 3, solve2(EXAMPLE2)
  end

  def test_solve2_input
    assert_equal 7_366, solve2(read_file('input.txt'))
  end
end
