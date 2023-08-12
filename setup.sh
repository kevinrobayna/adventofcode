#!/bin/bash
set -e

year=$(date +"%Y")
day=$(date +"%d")

# Forked the package to fix a few bugs, but i still having pushed it to PyPi
python3 ~/dev/aoc-to-md/aoc_to_md.py -y $year -d $day -o $year -i

FILE=./$year/day-$day/main.py
echo "AoC: Setting up day $day in $year"
if [ -f "$FILE" ]; then
  echo "AoC: $FILE already exists. Skipping."
else
  echo "AoC: Creating template file for day $day in $year"
  cat <<EOF >$FILE
from pathlib import Path


def compare_solutions(expected, actual):
    if expected != actual:
        raise Exception(f"Expected #{expected} but got #{actual}")

    print(f"Congratulations! Got expected result ({expected})")


def read_file(filename):
    return Path(__file__).parent.joinpath(filename).read_text()


def part1(filename):
    """Solve part 1."""


def part2(filename):
    """Solve part 2."""


if __name__ == "__main__":
    compare_solutions(-1, part1('test.txt'))
    print(f"Part1, {part1('input.txt')}")

    compare_solutions(5, part2('test.txt'))
    print(f"Part2, {part2('input.txt')}")

EOF
fi
