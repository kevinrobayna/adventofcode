#!/bin/bash
set -e

while getopts ":d:y:" opt; do
	case $opt in
	d)
		day="$OPTARG"
		;;
	y)
		year="$OPTARG"
		;;
	\?)
		echo "Invalid option -$OPTARG" >&2
		exit 1
		;;
	esac

	case $OPTARG in
	-*)
		echo "Option $opt needs a valid argument"
		exit 1
		;;
	esac
done

if [ -z ${year} ]; then
	year=$(date +"%Y")
fi
if [ -z ${day} ]; then
	day=$(date +"%d")
fi

echo "AoC: Setting up day $day in $year"
aoc2md -y $year -d $day 
FILE=./$year/day-$day/main.rb
if [ -f "$FILE" ]; then
	echo "AoC: $FILE already exists. Skipping."
else
	echo "AoC: Creating template file for day $day in $year"
	cat <<EOF >$FILE
# frozen_string_literal: true

require "pry"
require "minitest/autorun"

def read_file(filename)
  # Get the directory of the currently executing script
  # Join the script directory with the filename
  # Read the content of the file
  File.read(File.join(__dir__, filename))
end

def solve(filename)
  read_file(filename)
  0
end

def solve2(filename)
  read_file(filename)
  0
end

class AoCTest < Minitest::Test
  def test_solve
    assert solve("test.txt") == 0
  end

  def test_solve2
    assert solve2("test.txt") == 0
  end
end

puts 'Part1', solve('input.txt')
puts 'Part2', solve2('input.txt')
EOF
fi
