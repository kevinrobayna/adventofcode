# frozen_string_literal: true

require "matrix"

def read_file(*)
  File.read(File.join(File.absolute_path(""), *))
end

module Day04
  class Solver
    def initialize(content)
      @numbers, @data = parse_content(content)
      @visited = Array.new(@data.size) { |_| Matrix.zero(5, 5) }
      @boards_left = Array.new(@data.size, 0)
    end

    def solve
      solve_problem 1
    end

    def solve2
      solve_problem @boards_left.size
    end

    private

    def solve_problem(required_bingos)
      @numbers.each do |bingo_number|
        board_numbers = find_bingo(bingo_number)

        next if board_numbers.empty?

        board_numbers.each { |board_number| @boards_left[board_number] = 1 }

        next unless @boards_left.sum == required_bingos

        return sum_board(bingo_number, board_numbers.last)
      end
    end

    def sum_board(bingo_number, board_number)
      sum = 0
      5.times do |i|
        5.times do |j|
          sum += @data[board_number][i, j] if @visited[board_number][i, j].zero?
        end
      end
      sum * bingo_number
    end

    def find_bingo(bingo_number)
      positions = []

      @data.each_index do |inx|
        next if winning_board?(inx)

        5.times do |i|
          5.times do |j|
            next unless @data[inx][i, j] == bingo_number

            @visited[inx][i, j] = 1

            positions.append inx if winning_board?(inx)
          end
        end
      end
      positions
    end

    def winning_board?(inx)
      5.times do |z|
        if (0...5).map { |x| @visited[inx][z, x] }.sum == 5 || (0...5).map { |x| @visited[inx][x, z] }.sum == 5
          return true
        end
      end
      false
    end

    def parse_content(content)
      lines = content.split("\n")
      numbers = lines[0].split(",").reject(&:empty?).map(&:to_i)
      filtered_lines = lines.select { |num| num != lines[0] && !num.empty? }
      data = []
      rows = []

      filtered_lines.each_with_index do |line, row|
        rows.append(line.split(" ").reject(&:empty?).map(&:to_i))
        if row.positive? && ((row + 1) % 5).zero?
          data.append(Matrix.rows(rows))
          rows = []
        end
      end
      [numbers, data]
    end
  end
end

test = read_file("test.txt")
real = read_file("input.txt")

puts "Part1 Test", Day04::Solver.new(test).solve
puts "Part1", Day04::Solver.new(real).solve
puts "Part2 Test", Day04::Solver.new(test).solve2
puts "Part2", Day04::Solver.new(real).solve2
