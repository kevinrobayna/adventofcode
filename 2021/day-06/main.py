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

