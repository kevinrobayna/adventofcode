# frozen_string_literal: true

require 'matrix'

def compare_solutions(expected, actual)
  raise "Expected #{expected} but got #{actual}" unless expected == actual

  puts "Congratulations! Got expected result (#{expected})"
end

def read_file(filename)
  # Get the directory of the currently executing script
  # Join the script directory with the filename
  # Read the content of the file
  File.read(File.join(__dir__, filename))
end

def solve(filename)
  m = parse_input(filename)
  visited = Matrix.zero(m.row_count, m.column_count)
  visited.each_with_index do |_, inx_i, inx_j|
    visited[inx_i, inx_j] = if edge?(inx_i, inx_j, m.row_count, m.column_count)
                              true
                            else
                              false
                            end
  end

  (1...m.row_count).each do |row|
    highest = m[0, row]
    highest_reverse = m[m.column_count - 1, row]

    (1...m.column_count).each do |c_inx|
      if highest < m[c_inx, row]
        highest = m[c_inx, row]
        visited[c_inx, row] = true
      end

      if highest_reverse < m[m.column_count - c_inx, row]
        highest_reverse = m[m.column_count - c_inx, row]
        visited[m.column_count - c_inx, row] = true
      end
    end
  end

  (1...m.column_count).each do |column|
    highest = m[column, 0]
    highest_reverse = m[column, m.row_count - 1]

    (1...m.row_count).each do |r_inx|
      if highest < m[column, r_inx]
        highest = m[column, r_inx]
        visited[column, r_inx] = true
      end

      reverse_inx = m.row_count - r_inx
      if highest_reverse < m[column, reverse_inx]
        highest_reverse = m[column, reverse_inx]
        visited[column, reverse_inx] = true
      end
    end
  end

  visited.map do |cell, _, _|
    if cell
      1
    else
      0
    end
  end.sum
end

def parse_input(filename)
  lines = read_file(filename).split("\n")
  m = Matrix.zero(lines[0].length, lines.length)
  lines.each_with_index do |line, inx_i|
    line.chars.each_with_index do |tree, inx_j|
      m[inx_i, inx_j] = tree.to_i
    end
  end
  m
end

def solve2(filename)
  m = parse_input(filename)
  scenic_score = Matrix.zero(m.row_count, m.column_count)
  m.each_with_index do |_, inx_i, inx_j|
    next if edge?(inx_i, inx_j, m.row_count, m.column_count)

    scenic_score[inx_i, inx_j] = calculate_scenic_score(m, inx_i, inx_j)
  end

  scenic_score.map { |i| i }.max
end

def edge?(inx_i, inx_j, rows, columns)
  inx_i.zero? || inx_i == (rows - 1) || inx_j.zero? || (inx_j == columns - 1)
end

def calculate_scenic_score(trees, inx_i, inx_j)
  current = trees[inx_i, inx_j]
  count_down = 0
  (1...trees.row_count).each do |i|
    count_down += 1

    break if inx_i + i == (trees.row_count - 1)
    break if current <= trees[inx_i + i, inx_j]
  end

  count_up = 0
  (1..inx_i).each do |i|
    count_up += 1

    break if (inx_i - i).zero?
    break if current <= trees[inx_i - i, inx_j]
  end

  count_right = 0
  (1...trees.column_count).each do |j|
    count_right += 1

    break if inx_j + j == (trees.column_count - 1)
    break if current <= trees[inx_i, inx_j + j]
  end

  count_left = 0
  (1..inx_j).each do |j|
    count_left += 1

    break if (inx_j - j).zero?
    break if current <= trees[inx_i, inx_j - j]
  end

  count_up * count_down * count_left * count_right
end

compare_solutions(21, solve('test.txt'))
puts 'Part1', solve('input.txt')

compare_solutions(8, solve2('test.txt'))
puts 'Part2', solve2('input.txt')
