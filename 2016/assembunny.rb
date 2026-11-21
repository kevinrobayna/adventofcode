# frozen_string_literal: true

# Assembunny interpreter shared by 2016 days 12, 23 and 25.
# Supports cpy/inc/dec/jnz, tgl (day 23) and out (day 25), and short-circuits
# "inc x / dec y / jnz y -2" addition loops, and the multiplication loops built from them
# ("cpy b c / <add c to a> / dec d / jnz d -5"), so multiplication-heavy programs finish quickly.
class Assembunny
  TOGGLE = { 'inc' => 'dec', 'dec' => 'inc', 'tgl' => 'inc', 'out' => 'inc', 'jnz' => 'cpy', 'cpy' => 'jnz' }.freeze

  attr_reader :registers

  def initialize(source, **registers)
    @program = source.lines.map(&:split).reject(&:empty?).map do |op, *args|
      [op, *args.map { |a| a.match?(/\A-?\d+\z/) ? a.to_i : a }]
    end
    @registers = { 'a' => 0, 'b' => 0, 'c' => 0, 'd' => 0 }.merge(registers.transform_keys(&:to_s))
  end

  # Runs until the program halts, or until the block passed for `out` returns :stop.
  def run(&out)
    regs = @registers
    prog = @program
    pc = 0
    while pc >= 0 && pc < prog.size
      if (target, source, scratch, times = multiplication_loop(pc))
        regs[target] += value(source) * regs[times]
        regs[scratch] = 0
        regs[times] = 0
        pc += 6
        next
      end

      if (target, counter = addition_loop(pc))
        regs[target] += regs[counter]
        regs[counter] = 0
        pc += 3
        next
      end

      op, x, y = prog[pc]
      case op
      when 'cpy' then regs[y] = value(x) if regs.key?(y)
      when 'inc' then regs[x] += 1 if regs.key?(x)
      when 'dec' then regs[x] -= 1 if regs.key?(x)
      when 'jnz'
        pc += value(y) - 1 unless value(x).zero?
      when 'tgl'
        i = pc + value(x)
        prog[i] = [TOGGLE.fetch(prog[i][0]), *prog[i][1..]] if i.between?(0, prog.size - 1)
      when 'out'
        break if out&.call(value(x)) == :stop
      end
      pc += 1
    end
    regs
  end

  private

  def value(x) = x.is_a?(Integer) ? x : @registers[x]

  # cpy src c / inc a / dec c / jnz c -2 / dec d / jnz d -5  =>  a += src * d
  def multiplication_loop(pc)
    cpy = @program[pc]
    dec, jnz = @program[pc + 4, 2]
    return unless cpy && jnz && cpy[0] == 'cpy' && dec[0] == 'dec' && jnz[0] == 'jnz' && jnz[1] == dec[1] && jnz[2] == -5

    target, counter = addition_loop(pc + 1)
    return unless counter == cpy[2] && @registers.key?(dec[1]) && ![target, counter].include?(dec[1])
    return if cpy[1] == target || cpy[1] == dec[1]

    [target, cpy[1], counter, dec[1]]
  end

  def addition_loop(pc)
    a, b, j = @program[pc, 3]
    return unless j && j[0] == 'jnz' && j[2] == -2

    inc, dec = [a, b].partition { |ins| ins[0] == 'inc' }.map(&:first)
    return unless inc && dec && dec[0] == 'dec' && j[1] == dec[1] && inc[1] != dec[1]
    return unless @registers.key?(inc[1]) && @registers.key?(dec[1])

    [inc[1], dec[1]]
  end
end
