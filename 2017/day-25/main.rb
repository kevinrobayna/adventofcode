# frozen_string_literal: true

require_relative '../../lib/aoc'

RubyVM::YJIT.enable if defined?(RubyVM::YJIT)

# Parses the blueprint into [start state, steps, {state => [[write, move, next] for 0, for 1]}].
def parse_blueprint(input)
  start = input[/Begin in state (\w)/, 1]
  steps = input[/after (\d+) steps/, 1].to_i
  rules = input.scan(/In state (\w):(.*?)(?=In state|\z)/m).to_h do |state, body|
    actions = body.scan(/value (\d)\.\s+- Move one slot to the (\w+)\.\s+- Continue with state (\w)/)
    [state, actions.map { |w, dir, nxt| [w.to_i, dir == 'right' ? 1 : -1, nxt] }]
  end
  [start, steps, rules]
end

def solve(input)
  state, steps, rules = parse_blueprint(input)
  tape = Hash.new(0)
  pos = 0
  steps.times do
    write, move, state = rules[state][tape[pos]]
    tape[pos] = write
    pos += move
  end
  tape.values.sum
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    Begin in state A.
    Perform a diagnostic checksum after 6 steps.

    In state A:
      If the current value is 0:
        - Write the value 1.
        - Move one slot to the right.
        - Continue with state B.
      If the current value is 1:
        - Write the value 0.
        - Move one slot to the left.
        - Continue with state B.

    In state B:
      If the current value is 0:
        - Write the value 1.
        - Move one slot to the left.
        - Continue with state A.
      If the current value is 1:
        - Write the value 1.
        - Move one slot to the right.
        - Continue with state A.
  INPUT

  def test_solve_example
    assert_equal 3, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 2_794, solve(read_file('input.txt'))
  end
end
