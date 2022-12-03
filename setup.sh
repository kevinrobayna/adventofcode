#!/bin/bash
set -e

year=$(date +"%Y")
day=$(date +"%d")

aoc-to-markdown -y $year -d $day -o $year -i

FILE=./$year/day-$day/main.rb
echo "AoC: Setting up day $day in $year"
if [ -f "$FILE" ]; then
  echo "AoC: $FILE already exists. Skipping."
else
  echo "AoC: Creating template file for day $day in $year"
  cat <<EOF >$FILE
# frozen_string_literal: true

def compare_solutions(expected, actual)
  raise "Expected #{expected} but got #{actual}" unless expected == actual
end

def read_file(*args)
  File.read(File.join(File.absolute_path('.'), *args))
end

def solve(filename)
  read_file(filename)
  0
end

def solve2(filename)
  read_file(filename)
  0
end

compare_solutions(0, solve('2022/day-03/test.txt'))
puts 'Part1', solve('2022/day-03/input.txt')

compare_solutions(0, solve2('2022/day-03/test.txt'))
puts 'Part2', solve2('2022/day-03/input.txt')
EOF
fi
