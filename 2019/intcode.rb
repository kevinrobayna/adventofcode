# frozen_string_literal: true

# Intcode virtual machine shared by the 2019 puzzles.
# `run` executes until the program halts or needs input that is not queued,
# and returns the outputs produced since the previous call.
class Intcode
  attr_reader :mem

  def self.parse(input)
    input.strip.split(',').map(&:to_i)
  end

  def initialize(program)
    @mem = Hash.new(0)
    (program.is_a?(String) ? Intcode.parse(program) : program).each_with_index { |v, i| @mem[i] = v }
    @ip = 0
    @base = 0
    @inputs = []
    @halted = false
  end

  def halted? = @halted

  def waiting? = !@halted && (@mem[@ip] % 100) == 3 && @inputs.empty?

  def <<(value)
    @inputs.concat(Array(value))
    self
  end

  def run(*inputs)
    @inputs.concat(inputs.flatten)
    out = []
    loop do
      op = @mem[@ip]
      case op % 100
      when 1 then write(op, 3, read(op, 1) + read(op, 2)) && (@ip += 4)
      when 2 then write(op, 3, read(op, 1) * read(op, 2)) && (@ip += 4)
      when 3
        return out if @inputs.empty?

        write(op, 1, @inputs.shift)
        @ip += 2
      when 4
        out << read(op, 1)
        @ip += 2
      when 5 then @ip = read(op, 1).zero? ? @ip + 3 : read(op, 2)
      when 6 then @ip = read(op, 1).zero? ? read(op, 2) : @ip + 3
      when 7 then write(op, 3, read(op, 1) < read(op, 2) ? 1 : 0) && (@ip += 4)
      when 8 then write(op, 3, read(op, 1) == read(op, 2) ? 1 : 0) && (@ip += 4)
      when 9
        @base += read(op, 1)
        @ip += 2
      when 99
        @halted = true
        return out
      else raise "bad opcode #{op} at #{@ip}"
      end
    end
  end

  # Runs an ASCII program with the given text lines and returns raw outputs.
  def run_ascii(*lines)
    run(lines.flat_map { |l| "#{l}\n".bytes })
  end

  private

  def mode(op, n) = (op / (10**(n + 1))) % 10

  def addr(op, n)
    case mode(op, n)
    when 0 then @mem[@ip + n]
    when 1 then @ip + n
    when 2 then @base + @mem[@ip + n]
    end
  end

  def read(op, n) = @mem[addr(op, n)]

  def write(op, n, value)
    @mem[addr(op, n)] = value
    true
  end
end
