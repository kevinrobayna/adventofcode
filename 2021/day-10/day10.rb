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
        find_invalid_char(expression, [@content[expression].first], 0)
      end.sum
    end

    def solve2
      0
    end

    private

    def find_invalid_char(expression, openings, position)
      next_pos = position + 1
      found = @content[expression][next_pos] || 'END'
      expected = get_closings(openings.last)
      if is_opening? found
        openings.append found
        find_invalid_char(expression, openings, next_pos)
      elsif expected == found
        openings.delete_at(openings.size - 1)
        find_invalid_char(expression, openings, next_pos)
      else
        chars_until_now = (0...next_pos).map { |x| @content[expression][x] }.join
        chars_until_end = ((next_pos + 1)...(@content[expression].size)).map { |x| @content[expression][x] }.join
        colored_found = "\e[0;31m#{found}\e[0m"
        points = calculate_score(found)
        if found == 'END'
          puts "#{expression} - #{chars_until_now}\e Expected #{expected}, but found #{colored_found} instead"
        else
          puts "#{expression} - #{chars_until_now}#{colored_found}#{chars_until_end} Expected #{expected}, but found #{found} instead. Points: #{points}"
        end
        points
      end
    end

    def calculate_score(char)
      case char
      when ')'
        3
      when ']'
        57
      when '}'
        1197
      when '>'
        25_137
      else
        0
      end
    end

    def get_opening(char)
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
        'END'
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

test = read_file('2021/day-10/test.txt')
real = read_file('2021/day-10/input.txt')

puts 'Part1 Test', Day10::Solver.new(test).solve
puts 'Part1', Day10::Solver.new(real).solve
puts 'Part2 Test', Day10::Solver.new(test).solve2
puts 'Part2', Day10::Solver.new(real).solve2



