# frozen_string_literal: true

require_relative '../../lib/aoc'

# Facing: 0 right, 1 down, 2 left, 3 up.
STEPS = [[0, 1], [1, 0], [0, -1], [-1, 0]].freeze

def parse_notes(input)
  board, path = input.split("\n\n")
  grid = board.split("\n")
  [grid, path.scan(/\d+|[LR]/)]
end

def tile(grid, row, col)
  return ' ' if row.negative? || col.negative?

  grid.fetch(row, '')[col] || ' '
end

def password(input)
  grid, path = parse_notes(input)
  row = 0
  col = grid[0].index('.')
  facing = 0
  path.each do |move|
    case move
    when 'R' then facing = (facing + 1) % 4
    when 'L' then facing = (facing - 1) % 4
    else
      move.to_i.times do
        nrow, ncol, nfacing = yield(grid, row, col, facing)
        break if grid[nrow][ncol] == '#'

        row = nrow
        col = ncol
        facing = nfacing
      end
    end
  end
  (1000 * (row + 1)) + (4 * (col + 1)) + facing
end

def solve(input)
  password(input) do |grid, row, col, facing|
    dr, dc = STEPS[facing]
    nrow = row + dr
    ncol = col + dc
    if tile(grid, nrow, ncol) == ' '
      # Wrap around: walk backwards to the farthest tile on the board.
      nrow = row
      ncol = col
      while tile(grid, nrow - dr, ncol - dc) != ' '
        nrow -= dr
        ncol -= dc
      end
    end
    [nrow, ncol, facing]
  end
end

# 3D vector helpers.
def vadd(a, b) = a.zip(b).map(&:sum)
def vneg(a) = a.map(&:-@)
def vscale(a, k) = a.map { |v| v * k }
def vdot(a, b) = a.zip(b).sum { |x, y| x * y }

# Folds the net into a cube. Each face (keyed by its block position) gets an outward normal and
# 3D unit vectors for its local "right" (x) and "down" (y) directions.
def fold_cube(grid)
  size = Integer.sqrt(grid.sum { |line| line.count('.#') } / 6)
  blocks = []
  grid.each_with_index do |line, row|
    line.chars.each_with_index { |ch, col| blocks << [row / size, col / size] if ch != ' ' }
  end
  blocks.uniq!
  faces = { blocks.first => { n: [0, 0, 1], x: [1, 0, 0], y: [0, 1, 0] } }
  queue = [blocks.first]
  until queue.empty?
    block = queue.shift
    f = faces[block]
    {
      [0, 1] => { n: f[:x], x: vneg(f[:n]), y: f[:y] },
      [1, 0] => { n: f[:y], x: f[:x], y: vneg(f[:n]) },
      [0, -1] => { n: vneg(f[:x]), x: f[:n], y: f[:y] },
      [-1, 0] => { n: vneg(f[:y]), x: f[:x], y: f[:n] }
    }.each do |(dr, dc), frame|
      neighbor = [block[0] + dr, block[1] + dc]
      next unless blocks.include?(neighbor) && !faces.key?(neighbor)

      faces[neighbor] = frame
      queue << neighbor
    end
  end
  [faces, size]
end

def cube_step(grid, cube, row, col, facing)
  faces, size = cube
  dr, dc = STEPS[facing]
  return [row + dr, col + dc, facing] if tile(grid, row + dr, col + dc) != ' '

  face = faces[[row / size, col / size]]
  # Cell centre in doubled coordinates: the cube spans -size..size on each axis.
  u = (2 * (col % size)) - (size - 1)
  v = (2 * (row % size)) - (size - 1)
  point = vadd(vadd(vscale(face[:x], u), vscale(face[:y], v)), vscale(face[:n], size))
  travel = vadd(vscale(face[:x], dc), vscale(face[:y], dr))
  # Step over the edge: one unit along the travel direction, one unit down the old normal.
  point = vadd(point, vadd(travel, vneg(face[:n])))
  target_block, target = faces.find { |_, f| f[:n] == travel }
  new_dir = vneg(face[:n])
  nu = vdot(point, target[:x])
  nv = vdot(point, target[:y])
  [(target_block[0] * size) + ((nv + size - 1) / 2),
   (target_block[1] * size) + ((nu + size - 1) / 2),
   STEPS.index([vdot(new_dir, target[:y]), vdot(new_dir, target[:x])])]
end

def solve2(input)
  cube = fold_cube(parse_notes(input).first)
  password(input) { |grid, row, col, facing| cube_step(grid, cube, row, col, facing) }
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
            ...#
            .#..
            #...
            ....
    ...#.......#
    ........#...
    ..#....#....
    ..........#.
            ...#....
            .....#..
            .#......
            ......#.

    10R5L5R10L4R5L5
  INPUT

  def test_solve_example
    assert_equal 6032, solve(EXAMPLE)
  end

  def test_solve_input
    assert_equal 159_034, solve(read_file('input.txt'))
  end

  def test_solve2_example
    assert_equal 5031, solve2(EXAMPLE)
  end

  def test_solve2_input
    assert_equal 147_245, solve2(read_file('input.txt'))
  end
end
