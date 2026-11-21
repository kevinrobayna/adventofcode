# frozen_string_literal: true

require_relative '../../lib/aoc'

Unit = Struct.new(:kind, :pos, :hp, :power)

class ElfDied < StandardError; end

# Positions are flat indexes y * width + x, so integer order is reading order.
class Combat
  def initialize(input, elf_power: 3, elves_must_survive: false)
    rows = input.lines(chomp: true)
    @width = rows.map(&:size).max
    @offsets = [-@width, -1, 1, @width].freeze
    @walls = []
    @units = []
    rows.each_with_index do |row, y|
      row.chars.each_with_index do |c, x|
        pos = (y * @width) + x
        @walls[pos] = c == '#'
        @units << Unit.new(c, pos, 200, c == 'E' ? elf_power : 3) if 'EG'.include?(c)
      end
    end
    @size = @walls.size
    @elves_must_survive = elves_must_survive
  end

  # Returns the outcome (full rounds * remaining hp).
  def run
    rounds = 0
    rounds += 1 while round
    rounds * @units.select { |u| u.hp.positive? }.sum(&:hp)
  end

  private

  # Plays a round; returns false if it ended early because no targets were left.
  def round
    @units.sort_by!(&:pos)
    @units.each do |unit|
      next if unit.hp <= 0

      targets = @units.select { |u| u.hp.positive? && u.kind != unit.kind }
      return false if targets.empty?

      move(unit, targets) unless adjacent_target(unit, targets)
      victim = adjacent_target(unit, targets)
      attack(unit, victim) if victim
    end
    @units.select! { |u| u.hp.positive? }
    true
  end

  def adjacent_target(unit, targets)
    targets.select { |t| @offsets.include?(t.pos - unit.pos) }.min_by { |t| [t.hp, t.pos] }
  end

  def attack(unit, victim)
    victim.hp -= unit.power
    raise ElfDied if victim.hp <= 0 && victim.kind == 'E' && @elves_must_survive
  end

  def distances(from, blocked)
    dist = Array.new(@size)
    dist[from] = 0
    queue = [from]
    i = 0
    while i < queue.size
      pos = queue[i]
      i += 1
      d = dist[pos] + 1
      @offsets.each do |o|
        n = pos + o
        next if dist[n] || blocked[n]

        dist[n] = d
        queue << n
      end
    end
    dist
  end

  def move(unit, targets)
    blocked = @walls.dup
    @units.each { |u| blocked[u.pos] = true if u.hp.positive? && !u.equal?(unit) }
    dist = distances(unit.pos, blocked)
    goal = targets.flat_map { |t| @offsets.map { |o| t.pos + o } }
                  .select { |p| dist[p] && !blocked[p] }.min_by { |p| [dist[p], p] }
    return unless goal

    back = distances(goal, blocked)
    unit.pos = @offsets.map { |o| unit.pos + o }.select { |p| back[p] }.min_by { |p| [back[p], p] }
  end
end

def solve(input)
  Combat.new(input).run
end

def solve2(input)
  (4..).each do |power|
    return Combat.new(input, elf_power: power, elves_must_survive: true).run
  rescue ElfDied
    next
  end
end

class AoCTest < Minitest::Test
  EXAMPLES = [
    [<<~MAP, 27_730, 4988],
      #######
      #.G...#
      #...EG#
      #.#.#G#
      #..G#E#
      #.....#
      #######
    MAP
    [<<~MAP, 36_334, nil],
      #######
      #G..#E#
      #E#E.E#
      #G.##.#
      #...#E#
      #...E.#
      #######
    MAP
    [<<~MAP, 39_514, 31_284],
      #######
      #E..EG#
      #.#G.E#
      #E.##E#
      #G..#.#
      #..E#.#
      #######
    MAP
    [<<~MAP, 27_755, 3478],
      #######
      #E.G#.#
      #.#G..#
      #G.#.G#
      #G..#.#
      #...E.#
      #######
    MAP
    [<<~MAP, 28_944, 6474],
      #######
      #.E...#
      #.#..G#
      #.###.#
      #E#G#G#
      #...#G#
      #######
    MAP
    [<<~MAP, 18_740, 1140]
      #########
      #G......#
      #.E.#...#
      #..##..G#
      #...##..#
      #...#...#
      #.G...G.#
      #.....G.#
      #########
    MAP
  ].freeze

  def test_solve_example
    EXAMPLES.each { |map, expected, _| assert_equal expected, solve(map) }
  end

  def test_solve_input
    assert_equal 207_059, solve(read_file('input.txt'))
  end

  def test_solve2_example
    EXAMPLES.each { |map, _, expected| assert_equal expected, solve2(map) if expected }
  end

  def test_solve2_input
    assert_equal 49_120, solve2(read_file('input.txt'))
  end
end
