# frozen_string_literal: true

def read_file(*args)
  File.read(File.join(File.absolute_path(''), *args))
end

module Day10

  class Solver

    def initialize(content)
      @content = parse_content(content)
    end

    def solve
      @content.each_index.map do |expression|
        find_invalid_char(expression, [@content.first.first], 0)
      end
    end

    def solve2
      0
    end

    private

    def find_invalid_char(expression, openings, position)
      next_pos = position + 1
      next_char = @content[expression][next_pos]
      expected_closings = openings.map { |x| get_closings(x) }
      if is_opening? next_char
        openings.append next_char
        find_invalid_char(expression, openings, next_pos)
      elsif expected_closings.include? next_char
        # remove 1 occurence of next_char from openings
        find_invalid_char(expression, openings, next_pos)
      elsif !expected_closings.include? next_char
        next_char
      end
    end

    def calculate_points(char)
      case char
      when ')'
        3
      when ']'
        5
      when '}'
        1197
      when '>'
        25_137
      else
        raise ArgumentError
      end
    end

    def get_openings(char)
      case char
      when ')'
        '('
      when ']'
        '['
      when '}'
        '{'
      when '>'
        '<'
      else
        raise ArgumentError
      end
    end

    def get_closings(char)
      case char
      when '('
        ')'
      when '['
        ']'
      when '{'
        '}'
      when '<'
        '>'
      else
        raise ArgumentError
      end
    end

    def is_opening?(char)
      %w|( [ { <|.include? char
    end

    def parse_content(content)
      content.split("\n").map { |line| line.split('') }
    end
  end
end

test = read_file('test.txt')
real = read_file('input.txt')

puts 'Part1 Test', Day10::Solver.new(test).solve
puts 'Part1', Day10::Solver.new(real).solve
puts 'Part2 Test', Day10::Solver.new(test).solve2
puts 'Part2', Day10::Solver.new(real).solve2



