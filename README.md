# Advent Of Code

Repo that contains my solutions to the advent of code

## Languages

Currently I'm aiming at doing everything with ruby since it's a language that I'm familiar with and it's easy to do
these kind of "scripts" with. I would love to do it with static languages like kotlin, java or golang but I don't want
to have a huge amount of setup so that the IDE can help me with the code.

## Structure

I'm currently using the [aoc2md](https://github.com/kevinrobayna/aoc2md) cli so that I can
download the problem description, the input and a template for the solution.

For example for the year 2021 and the day 5 I'd execute `aoc2md -y 2021 -d 5 -lang ruby` so that the cli would
download the problem in the folder 2021

## Running

Each day's `main.rb` is a self-contained Minitest file: example tests from the puzzle plus a test that locks in the
answer for my input. New days start from [`templates/main.rb`](templates/main.rb).

```sh
bundle install
bundle exec rake               # lint + fast solutions
bundle exec rake test YEAR=2015 # one year
bundle exec rake test:all      # include days marked `# aoc: slow`
ruby 2015/day-01/main.rb       # a single day
```

Days that take more than ~10 seconds are marked with a `# aoc: slow` comment and skipped by `rake test` (and CI).
