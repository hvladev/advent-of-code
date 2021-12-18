require "json"

example_input = File.read("18.example-input.txt").lines(chomp: true)
input = File.read("18.input.txt").lines(chomp: true)

def snail_add(a, b)
  snail_reduce("[#{a},#{b}]")
end

def snail_reduce(snail_number)
  loop do
    result = snail_explode(snail_number) || snail_split(snail_number)
    return snail_number if result.nil?
    snail_number = result
  end
end

def snail_explode(snail_number)
  exploding_pair_range = find_exploding_pair_range(snail_number)
  return unless exploding_pair_range

  explode_pair(exploding_pair_range, snail_number)
end

def find_exploding_pair_range(snail_number)
  nesting_level = 0
  start = nil

  snail_number.each_char.with_index do |char, index|
    case char
    when "["
      start = index if nesting_level == 4
      nesting_level += 1
    when "]"
      return start..index if start
      nesting_level -= 1
    end
  end

  nil
end

def explode_pair(pair_range, snail_number)
  x, y = snail_number[pair_range].scan(/\d+/)

  to_the_left = snail_number[0...pair_range.begin]
  to_the_left = to_the_left.sub(/(.*[\[,])(\d+)/) { "#{$1}#{$2.to_i + x.to_i}" }

  to_the_right = snail_number[(pair_range.end + 1)..]
  to_the_right = to_the_right.sub(/\d+/) { |d| d.to_i + y.to_i }

  to_the_left + "0" + to_the_right
end

def snail_split(snail_number)
  number_regex = /\d{2,}/
  return unless snail_number.match?(number_regex)

  snail_number.sub(number_regex) do |number|
    divided_by_two = number.to_i / 2.0
    "[#{divided_by_two.floor},#{divided_by_two.ceil}]"
  end
end

def magnitute(snail_number)
  memo = {}
  recur = ->(n) {
    if n.is_a? Integer
      n
    else
      a, b = n
      left_magnitute = memo[a] || magnitute(a)
      right_magnitute = memo[b] || magnitute(b)

      (3 * left_magnitute) + (2 * right_magnitute)
    end
  }

  recur.call(snail_number)
end

# === part 1

def solve_part_1(input)
  sum = input.reduce { |a, b| snail_add(a, b) }
  magnitute(JSON.parse(sum))
end

# p solve_part_1(example_input)
# => 4140

# p solve_part_1(input)
# => 4017

# === part 2

def solve_part_2(input)
  magnitudes =
    input.flat_map do |snail_number|
      input.map do |other_snail_number|
        sum = snail_add(snail_number, other_snail_number)
        magnitute(JSON.parse(sum))
      end
    end

  magnitudes.max
end

# p solve_part_2(example_input)
# => 3993

# p solve_part_2(input)
# => 4583
