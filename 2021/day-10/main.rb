# frozen_string_literal: true

def compare_solutions(expected, actual)
  raise "Expected #{expected} but got #{actual}" unless expected == actual

  puts "Congratulations! Got expected result (#{expected})"
end

def read_file(*)
  File.read(File.join(File.absolute_path(""), *))
end

def solve(filename)
  content = read_file(filename).split("\n").map { |line| line.chars }
  content.each_index.map do |expression|
    find_invalid_char(content, expression, [content[expression].first], 0)
  end.sum
end

def solve2(filename)
  read_file(filename)
  0
end

def find_invalid_char(content, expression, openings, position)
  next_pos = position + 1
  found = content[expression][next_pos] || "END"
  expected = get_closings(openings.last)
  if opening? found
    openings.append found
    find_invalid_char(content, expression, openings, next_pos)
  elsif expected == found
    openings.delete_at(openings.size - 1)
    find_invalid_char(content, expression, openings, next_pos)
  else
    chars_until_now = (0...next_pos).map { |x| content[expression][x] }.join
    chars_until_end = ((next_pos + 1)...(content[expression].size)).map { |x| content[expression][x] }.join
    colored_found = "\e[0;31m#{found}\e[0m"
    points = calculate_score(found)
    if found == "END"
      puts "#{expression} - #{chars_until_now}\e Expected #{expected}, but found #{colored_found} instead"
    else
      puts "#{expression} -#{chars_until_now}#{colored_found}#{chars_until_end} Expected #{expected}, but found #{found} instead. Points: #{points}"
    end
    points
  end
end

def calculate_score(char)
  case char
  when ")"
    3
  when "]"
    57
  when "}"
    1197
  when ">"
    25_137
  else
    0
  end
end

def get_opening(char)
  case char
  when ")"
    "("
  when "]"
    "["
  when "}"
    "{"
  when ">"
    "<"
  else
    raise ArgumentError
  end
end

def get_closings(char)
  case char
  when "("
    ")"
  when "["
    "]"
  when "{"
    "}"
  when "<"
    ">"
  else
    "END"
  end
end

def opening?(char)
  %w|( [ { <|.include? char
end

compare_solutions(26_397, solve("test.txt"))
puts "Part1", solve("input.txt")

compare_solutions(288_957, solve2("test.txt"))
puts "Part2", solve2("input.txt")
