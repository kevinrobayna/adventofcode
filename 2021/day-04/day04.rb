# frozen_string_literal: true

require 'matrix'
require 'ostruct'

def read_file(*args)
  File.read(File.join(File.absolute_path(''), *args))
end

module Day04

  class Solver

    def initialize(content)
      @numbers, @data = parse_content(content)
      @visited = Array.new(@data.size) { |_| Matrix.zero(5, 5) }
      @boards_left = Array.new(@data.size, 0)
    end

    def solve
      @numbers.each do |bingo_number|
        board_number = find_bingo(bingo_number)

        next if board_number.nil?

        return sum_board(bingo_number, board_number)
      end
    end

    def solve2
      @numbers.each do |bingo_number|
        board_number = find_bingo(bingo_number)

        next if board_number.nil?

        @boards_left[board_number] = 1

        next unless @boards_left.sum == @boards_left.size

        return sum_board(bingo_number, board_number)
      end
    end

    private

    def sum_board(bingo_number, board_number)
      sum = 0
      (0...5).each do |i|
        (0...5).each do |j|
          sum += @data[board_number][i, j] if @visited[board_number][i, j].zero?
        end
      end
      sum * bingo_number
    end

    def find_bingo(bingo_number)
      positions = []

      @data.each_index do |inx|
        (0...5).each do |i|
          (0...5).each do |j|
            next unless @data[inx][i, j] == bingo_number

            @visited[inx][i, j] = 1
            positions.append OpenStruct.new(i: i, j: j, m: inx)
          end
        end
      end
      positions.each do |pos|
        row_bingo = @visited[pos.m][pos.i, 0] +
          @visited[pos.m][pos.i, 1] +
          @visited[pos.m][pos.i, 2] +
          @visited[pos.m][pos.i, 3] +
          @visited[pos.m][pos.i, 4] == 5
        column_bingo = @visited[pos.m][0, pos.j] +
          @visited[pos.m][1, pos.j] +
          @visited[pos.m][2, pos.j] +
          @visited[pos.m][3, pos.j] +
          @visited[pos.m][4, pos.j] == 5
        return pos.m if row_bingo || column_bingo
      end
      nil
    end

    def parse_content(content)
      lines = content.split("\n")
      numbers = lines[0].split(',').reject(&:empty?).map(&:to_i)
      filtered_lines = lines.select { |num| num != lines[0] && !num.empty? }
      data = []
      rows = []

      filtered_lines.each_with_index do |line, row|
        rows.append(line.split(' ').reject(&:empty?).map(&:to_i))
        if row.positive? && ((row + 1) % 5).zero?
          data.append(Matrix.rows(rows))
          rows = []
        end
      end
      [numbers, data]
    end
  end
end

test = read_file('test.txt')
real = read_file('input.txt')

puts 'Part1 Test', Day04::Solver.new(test).solve
puts 'Part1', Day04::Solver.new(real).solve
puts 'Part2 Test', Day04::Solver.new(test).solve2
puts 'Part2', Day04::Solver.new(real).solve2

