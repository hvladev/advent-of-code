example_input = File.read("08.example-input.txt").lines(chomp: true)
input = File.read("08.input.txt").lines(chomp: true)

# === part 1

def solve_part_1(entries)
  output_values = entries.map { |e| e.split(" | ")[1].split(" ") }.flatten

  output_values.count { |v| [2, 4, 3, 7].include?(v.length) }
end

solve_part_1(example_input) # => 26
solve_part_1(input) # => 392

# === part 2

def solve_part_2(entries)
  entries.map { |entry| decode_output_value(entry) }.sum
end

def decode_output_value(entry)
  patterns, output = entry.split(" | ").map(&:split)
  patterns = patterns.map { |p| p.chars.sort }
  digits = []

  digits[1] = patterns.find { |p| p.length == 2 }
  patterns.delete(digits[1])

  digits[4] = patterns.find { |p| p.length == 4 }
  patterns.delete(digits[4])

  digits[7] = patterns.find { |p| p.length == 3 }
  patterns.delete(digits[7])

  digits[8] = patterns.find { |p| p.length == 7 }
  patterns.delete(digits[8])

  digits[9] = patterns.find { |p| contains_segments?(p, digits[4]) }
  patterns.delete(digits[9])

  digits[6] = patterns.find { |p| contains_segments?(p, digits[8] - digits[1]) }
  patterns.delete(digits[6])

  digits[5] = patterns.find { |p| contains_segments?(p, digits[4] - digits[1]) }
  patterns.delete(digits[5])

  digits[3] = patterns.find { |p| contains_segments?(digits[9], p) }
  patterns.delete(digits[3])

  digits[0] = patterns.find { |p| contains_segments?(p, digits[1]) }
  patterns.delete(digits[0])

  digits[2] = patterns.pop

  output.map { |p| digits.index(p.chars.sort) }.join.to_i
end

def contains_segments?(pattern, segments)
  (pattern & segments).length == segments.length
end

solve_part_2(example_input) # => 61229
solve_part_2(input) # => 1004688
