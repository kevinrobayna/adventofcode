# frozen_string_literal: true

require "matrix"
require "ostruct"

def read_file(*)
  File.read(File.join(File.absolute_path(""), *))
end

module Day05
  class Solver
    def initialize(content)
      @content = parse_content(content)
      max_x = max_y = 0
      @content.each do |from, to|
        max_x = [max_x, from.x, to.x].max
        max_y = [max_y, from.y, to.y].max
      end
      size = [max_x, max_y].max
      @matrix = Matrix.zero(size + 1, size + 1)
    end

    def solve
      movements = @content.select { |from, to| from.x == to.x || from.y == to.y }
      solve_problem(movements)
      sum_board
    end

    def solve2
      solve_problem(@content)
      sum_board
    end

    private

    def solve_problem(movements)
      movements.each do |from, to|
        if from.x == to.x
          min_y, max_y = [from.y, to.y].sort
          (min_y..max_y).each { |inx| @matrix[inx, from.x] += 1 }
        elsif from.y == to.y
          min_x, max_x = [from.x, to.x].sort
          (min_x..max_x).each { |inx| @matrix[from.y, inx] += 1 }
        else
          pos_x = from.x
          pos_y = from.y
          @matrix[pos_y, pos_x] += 1
          while pos_x != to.x && pos_y != to.y
            pos_x = (pos_x < to.x) ? pos_x + 1 : pos_x - 1
            pos_y = (pos_y < to.y) ? pos_y + 1 : pos_y - 1
            @matrix[pos_y, pos_x] += 1
          end
        end
      end
    end

    def sum_board
      (@matrix.select { |v| v >= 2 } || []).count
    end

    def parse_content(content)
      content.split("\n").map do |line|
        from, to = line.split("->")

        x1, y1 = from.strip.split(",").map(&:to_i)
        x2, y2 = to.strip.split(",").map(&:to_i)

        [OpenStruct.new(x: x1, y: y1), OpenStruct.new(x: x2, y: y2)]
      end
    end
  end
end

test = read_file("test.txt")
real = read_file("input.txt")

puts "Part1 Test", Day05::Solver.new(test).solve
puts "Part1", Day05::Solver.new(real).solve
puts "Part2 Test", Day05::Solver.new(test).solve2
puts "Part2", Day05::Solver.new(real).solve2
