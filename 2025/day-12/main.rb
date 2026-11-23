# frozen_string_literal: true

require 'minitest/autorun'

# Reads a file that lives next to this solution.
def read_file(filename)
  File.read(File.join(__dir__, filename))
end

# All distinct rotations/flips of a shape, each as [dr, dc] offsets from its first cell in row-major order.
def orientations(cells)
  variants = 4.times.flat_map do |turn|
    rotated = cells.map { |r, c| turn.times.reduce([r, c]) { |(y, x), _| [x, -y] } }
    [rotated, rotated.map { |r, c| [r, -c] }]
  end
  variants.map do |v|
    sorted = v.sort
    sorted.map { |r, c| [r - sorted[0][0], c - sorted[0][1]] }
  end.uniq
end

def parse(input)
  blocks = input.split("\n\n")
  regions = blocks.pop.lines.map do |line|
    size, counts = line.split(':')
    [size.split('x').map(&:to_i), counts.split.map(&:to_i)]
  end
  shapes = blocks.map do |block|
    block.lines.drop(1).each_with_index.flat_map do |row, r|
      row.chomp.chars.each_index.select { |c| row[c] == '#' }.map { |c| [r, c] }
    end
  end
  [shapes, regions]
end

# Exact packing search: the first empty cell is either left blank (uses slack) or covered by
# a placement anchored there.
class Packer
  def initialize(shapes, width, height)
    @width = width
    @height = height
    @placements = shapes.map { |cells| anchored_masks(orientations(cells)) }
  end

  def fits?(counts, sizes)
    @counts = counts.dup
    @dead = Set.new
    slack = (@width * @height) - counts.zip(sizes).sum { |n, s| n * s }
    slack >= 0 && search(0, 0, slack)
  end

  private

  def anchored_masks(variants)
    Array.new(@width * @height) do |cell|
      r, c = cell.divmod(@width)
      variants.filter_map do |offsets|
        points = offsets.map { |dr, dc| [r + dr, c + dc] }
        next unless points.all? { |y, x| y < @height && x >= 0 && x < @width }

        points.sum { |y, x| 1 << ((y * @width) + x) }
      end
    end
  end

  def search(grid, cell, slack)
    return true if @counts.all?(&:zero?)

    key = [grid, *@counts]
    return false if @dead.include?(key)

    found = try_cell(grid, cell, slack)
    @dead << key unless found
    found
  end

  def try_cell(grid, cell, slack)
    cell += 1 while grid[cell] == 1
    return false if cell >= @width * @height

    @counts.each_with_index do |count, shape|
      next if count.zero?

      @counts[shape] -= 1
      found = @placements[shape][cell].any? { |mask| grid.nobits?(mask) && search(grid | mask, cell + 1, slack) }
      @counts[shape] += 1
      return true if found
    end
    slack.positive? && search(grid | (1 << cell), cell + 1, slack - 1)
  end
end

def region_fits?(shapes, (width, height), counts)
  sizes = shapes.map(&:size)
  return false if counts.zip(sizes).sum { |n, s| n * s } > width * height
  return true if (width / 3) * (height / 3) >= counts.sum

  Packer.new(shapes, width, height).fits?(counts, sizes)
end

def solve(input)
  shapes, regions = parse(input)
  regions.count { |size, counts| region_fits?(shapes, size, counts) }
end

class AoCTest < Minitest::Test
  EXAMPLE = <<~INPUT
    0:
    ###
    ##.
    ##.

    1:
    ###
    ##.
    .##

    2:
    .##
    ###
    ##.

    3:
    ##.
    ###
    ##.

    4:
    ###
    #..
    ###

    5:
    ###
    .#.
    ###

    4x4: 0 0 0 0 2 0
    12x5: 1 0 1 0 2 2
    12x5: 1 0 1 0 3 2
  INPUT

  def test_solve_example
    assert_equal 2, solve(EXAMPLE)
  end

  def test_feasible_example_regions
    shapes, regions = parse(EXAMPLE)
    assert(regions.first(2).all? { |size, counts| region_fits?(shapes, size, counts) })
  end

  def test_area_shortcuts
    shapes, = parse(EXAMPLE)
    refute region_fits?(shapes, [3, 3], [0, 0, 0, 0, 2, 0])
    assert region_fits?(shapes, [9, 6], [1, 1, 1, 1, 1, 1])
  end

  def test_orientations
    assert_equal 4, orientations([[0, 0], [0, 1], [0, 2], [1, 0], [2, 0], [2, 1], [2, 2]]).size
    assert_equal 2, orientations([[0, 0], [0, 1], [0, 2], [1, 1], [2, 0], [2, 1], [2, 2]]).size
  end

  def test_solve_input
    assert_equal 593, solve(read_file('input.txt'))
  end
end
