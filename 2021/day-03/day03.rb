def read_file(*args)
  File.read(File.join(File.absolute_path(''), *args))
end

module Day03

  class Solver

    def initialize(content)
      @content = content
    end

    attr_reader :content

    def solve
      content = parse_content
      gamma = ''
      epsilon = ''
      (0...content.first.length).each do |index|
        zeros, ones = find_most_common_digit_in_column(content, index)
        if zeros > ones
          gamma << '0'
          epsilon << '1'
        else
          gamma << '1'
          epsilon << '0'
        end
      end

      gamma.to_i(2) * epsilon.to_i(2)
    end

    def solve2
      possible_ox_rates = parse_content
      (0...possible_ox_rates.first.length).each do |index|
        zeros, ones = find_most_common_digit_in_column(possible_ox_rates, index)
        if ones >= zeros
          possible_ox_rates.select! { |num| num[index].to_i.eql?(1) }
        else
          possible_ox_rates.select! { |num| num[index].to_i.zero? }
        end
      end

      possible_co2_rates = parse_content
      (0...possible_co2_rates.first.length).each do |index|
        zeros, ones = find_most_common_digit_in_column(possible_co2_rates, index)
        if ones < zeros
          possible_co2_rates.select! { |num| num[index].to_i.eql?(1) }
        elsif zeros < ones
          possible_co2_rates.select! { |num| num[index].to_i.zero? }
        else
          possible_co2_rates.select! { |num| num[index].to_i.zero? }
        end

        break if possible_co2_rates.count <= 1
      end

      oxygen = possible_ox_rates[0]
      co2 = possible_co2_rates[0]

      oxygen.to_i(2) * co2.to_i(2)
    end

    private

    def find_most_common_digit_in_column(values, index)
      zeros = values.count { |element| element[index].to_i.zero? }
      [zeros, (values.count - zeros).abs]
    end

    def parse_content
      @content.split("\n")
    end

  end
end

test = read_file('2021/day-03/test.txt')
real = read_file('2021/day-03/input.txt')

puts 'Part1 Test', Day03::Solver.new(test).solve
puts 'Part1', Day03::Solver.new(real).solve
puts 'Part2 Test', Day03::Solver.new(test).solve2
puts 'Part2', Day03::Solver.new(real).solve2

