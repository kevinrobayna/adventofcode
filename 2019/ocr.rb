# frozen_string_literal: true

# Decodes the 4x6 block letters Advent of Code renders (each letter is 5 columns wide incl. spacing).
module OCR
  GLYPHS = {
    '.##.#..##..######..##..#' => 'A', '###.#..####.#..##..####.' => 'B', '.##.#..##...#...#..#.##.' => 'C',
    '#####...###.#...#...####' => 'E', '#####...###.#...#...#...' => 'F', '.##.#..##...#.###..#.###' => 'G',
    '#..##..######..##..##..#' => 'H', '.###..#...#...#...#..###' => 'I', '..##...#...#...##..#.##.' => 'J',
    '#..##.#.##..#.#.#.#.#..#' => 'K', '#...#...#...#...#...####' => 'L', '.##.#..##..##..##..#.##.' => 'O',
    '###.#..##..####.#...#...' => 'P', '###.#..##..####.#.#.#..#' => 'R', '.####...#....##....####.' => 'S',
    '#..##..##..##..##..#.##.' => 'U', '#...#....#.#..#...#...#.' => 'Y', '####...#..#..#..#...####' => 'Z'
  }.freeze

  module_function

  # rows: array of 6 strings using '#' for lit pixels and anything else for dark ones.
  def decode(rows)
    rows = rows.map { |r| r.tr('^#', '.') }
    rows = rows.map { it[1..] } while rows.all? { it.start_with?('.') }
    width = rows.map(&:size).max
    rows = rows.map { it.ljust(width + 5, '.') }
    (0...width).step(5).map do |x|
      key = rows.map { it[x, 4] }.join
      GLYPHS.fetch(key) { raise "unknown glyph:\n#{rows.map { it[x, 5] }.join("\n")}" }
    end.join
  end
end
