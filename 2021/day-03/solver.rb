# rubocop:disable Style/FrozenStringLiteralComment

def compare_solutions(expected, actual)
  raise "Expected #{expected} but got #{actual}" unless expected == actual
end

def read_file(*args)
  File.read(File.join(File.absolute_path('.'), *args))
end

def solve(filename)
  content = read_file(filename).split("\n")
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

def solve2(filename)
  possible_ox_rates = read_file(filename).split("\n")
  (0...possible_ox_rates.first.length).each do |index|
    zeros, ones = find_most_common_digit_in_column(possible_ox_rates, index)
    if ones >= zeros
      possible_ox_rates.select! { |num| num[index].to_i.eql?(1) }
    else
      possible_ox_rates.select! { |num| num[index].to_i.zero? }
    end
  end

  possible_co2_rates = read_file(filename).split("\n")
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

def find_most_common_digit_in_column(values, index)
  zeros = values.count { |element| element[index].to_i.zero? }
  [zeros, (values.count - zeros).abs]
end

compare_solutions(198, solve('2021/day-03/test.txt'))
puts 'Part1', solve('2021/day-03/input.txt')

compare_solutions(230, solve2('2021/day-03/test.txt'))
puts 'Part2', solve2('2021/day-03/input.txt')

# rubocop:enable Style/FrozenStringLiteralComment
