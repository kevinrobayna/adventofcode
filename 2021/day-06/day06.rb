# frozen_string_literal: true

def read_file(*args)
  File.read(File.join(File.absolute_path(''), *args))
end

module Day06

  class Solver

    def initialize(content)
      @fish_ages = {}
      parse_content(content).each do |inx|
        @fish_ages[inx] = 0 if @fish_ages[inx].nil?
        @fish_ages[inx] += 1
      end
    end

    def solve
      calculate_fish_pool 80
    end

    def solve2
      calculate_fish_pool 256
    end

    private

    def calculate_fish_pool(times)
      (1..times).each do
        fish_ages_copy = {}
        (8.downto 0).each do |inx|
          next if @fish_ages[inx].nil?

          if inx.zero?
            on_8 = fish_ages_copy[8] || 0
            on_6 = fish_ages_copy[6] || 0
            on_0 = @fish_ages[inx]
            fish_ages_copy[8] = on_8 + on_0
            fish_ages_copy[6] = on_6 + on_0
          else
            fish_ages_copy[inx - 1] = @fish_ages[inx]
          end
        end
        @fish_ages = fish_ages_copy.clone
      end
      @fish_ages.values.sum
    end

    def parse_content(content)
      content.split("\n").first.split(',').map(&:to_i)
    end
  end
end

test = read_file('test.txt')
real = read_file('input.txt')

puts 'Part1 Test', Day06::Solver.new(test).solve
puts 'Part1', Day06::Solver.new(real).solve
puts 'Part2 Test', Day06::Solver.new(test).solve2
puts 'Part2', Day06::Solver.new(real).solve2


