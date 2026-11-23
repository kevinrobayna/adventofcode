# frozen_string_literal: true

# The 2018 wrist device ("elfcode"): 16 opcodes over registers, used by days 16, 19 and 21.
module Device
  OPS = {
    addr: ->(r, a, b) { r[a] + r[b] },
    addi: ->(r, a, b) { r[a] + b },
    mulr: ->(r, a, b) { r[a] * r[b] },
    muli: ->(r, a, b) { r[a] * b },
    banr: ->(r, a, b) { r[a] & r[b] },
    bani: ->(r, a, b) { r[a] & b },
    borr: ->(r, a, b) { r[a] | r[b] },
    bori: ->(r, a, b) { r[a] | b },
    setr: ->(r, a, _) { r[a] },
    seti: ->(_, a, _) { a },
    gtir: ->(r, a, b) { a > r[b] ? 1 : 0 },
    gtri: ->(r, a, b) { r[a] > b ? 1 : 0 },
    gtrr: ->(r, a, b) { r[a] > r[b] ? 1 : 0 },
    eqir: ->(r, a, b) { a == r[b] ? 1 : 0 },
    eqri: ->(r, a, b) { r[a] == b ? 1 : 0 },
    eqrr: ->(r, a, b) { r[a] == r[b] ? 1 : 0 }
  }.freeze

  module_function

  # Executes one instruction in place on registers.
  def execute(regs, op, a, b, c)
    regs[c] = OPS.fetch(op).call(regs, a, b)
    regs
  end

  # Parses "#ip N" programs into [ip_register, [[op, a, b, c], ...]].
  def parse(input)
    lines = input.lines(chomp: true).reject(&:empty?)
    ip = lines.shift[/\d+/].to_i
    program = lines.map do |l|
      op, *args = l.split
      [op.to_sym, *args.map(&:to_i)]
    end
    [ip, program]
  end

  # Runs a program until the ip leaves it. The block (optional) is called with (ip, regs) before each
  # instruction; returning :halt from it stops execution. Returns the registers.
  def run(ip_reg, program, regs = [0] * 6)
    ip = 0
    while ip >= 0 && ip < program.size
      break if block_given? && yield(ip, regs) == :halt

      op, a, b, c = program[ip]
      regs[ip_reg] = ip
      regs[c] = OPS[op].call(regs, a, b)
      ip = regs[ip_reg] + 1
    end
    regs
  end
end
