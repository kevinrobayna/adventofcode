# frozen_string_literal: true

require_relative '../../lib/aoc'

Cart = Struct.new(:x, :y, :dx, :dy, :turns, :crashed)

DIRS = { '>' => [1, 0], '<' => [-1, 0], '^' => [0, -1], 'v' => [0, 1] }.freeze

def parse_tracks(input)
  grid = input.lines(chomp: true)
  carts = []
  grid.each_with_index do |row, y|
    row.chars.each_with_index do |c, x|
      carts << Cart.new(x, y, *DIRS[c], 0, false) if DIRS.key?(c)
    end
  end
  [grid, carts]
end

def move(cart, grid)
  cart.x += cart.dx
  cart.y += cart.dy
  case grid[cart.y][cart.x]
  when '/' then cart.dx, cart.dy = -cart.dy, -cart.dx
  when '\\' then cart.dx, cart.dy = cart.dy, cart.dx
  when '+'
    case cart.turns % 3
    when 0 then cart.dx, cart.dy = cart.dy, -cart.dx # left
    when 2 then cart.dx, cart.dy = -cart.dy, cart.dx # right
    end
    cart.turns += 1
  end
end

# Yields each crash location in order; returns the last surviving cart when one remains.
def simulate(input)
  grid, carts = parse_tracks(input)
  loop do
    carts.sort_by! { |c| [c.y, c.x] }
    carts.each do |cart|
      next if cart.crashed

      move(cart, grid)
      other = carts.find { |o| !o.equal?(cart) && !o.crashed && o.x == cart.x && o.y == cart.y }
      next unless other

      cart.crashed = other.crashed = true
      yield cart.x, cart.y
    end
    carts.reject!(&:crashed)
    return carts.first if carts.size <= 1
  end
end

def solve(input)
  simulate(input) { |x, y| return "#{x},#{y}" }
end

def solve2(input)
  last = simulate(input) { nil }
  "#{last.x},#{last.y}"
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~'INPUT'
    /->-\
    |   |  /----\
    | /-+--+-\  |
    | | |  | v  |
    \-+-/  \-+--/
      \------/
  INPUT

  EXAMPLE2 = <<~'INPUT'
    />-<\
    |   |
    | /<+-\
    | | | v
    \>+</ |
      |   ^
      \<->/
  INPUT

  def test_solve_example
    assert_equal '7,3', solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal '40,90', solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal '6,4', solve2(EXAMPLE2)
  end

  def test_solve2_input
    assert_equal '65,81', solve2(read_file('input.txt'))
  end
end
