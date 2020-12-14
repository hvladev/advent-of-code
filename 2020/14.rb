input = File.readlines("14.input.txt", chomp: true)

def parse_mask(line)
  line =~ /\Amask = (.+)\z/ && $1
end

def parse_memory_write(line)
  line =~ /\Amem\[(\d+)\] = (\d+)\z/ && [$1, $2].map(&:to_i)
end

# === part 1

def apply_mask(mask, value)
  value = value.to_s(2).rjust(36, "0")

  mask.chars.zip(value.chars)
    .map { |m, v| m != "X" ? m : v }
    .join
    .to_i(2)
end

def solve_part1(input)
  mem = {}
  current_mask = nil

  input.each do |line|
    if line.start_with?("mask")
      current_mask = parse_mask(line)
      next
    else
      address, value = parse_memory_write(line)
      mem[address] = apply_mask(current_mask, value)
    end
  end

  mem.values.sum
end

# p solve_part1(input)
# => 7440382076205
# p solve_part1(input) == 7440382076205


# === part 2

def apply_mask(mask, address)
  address = address.to_s(2).rjust(36, "0")
  address = mask.chars.zip(address.chars).map { |m, v| m != "0" ? m : v }.join

  actual_addresses = [address.dup]

  while (address =~ /X/) do
    i = address.index("X")

    actual_addresses = actual_addresses.flat_map do |v|
      v1 = v.dup
      v1[i] = "0"

      v2 = v.dup
      v2[i] = "1"

      [v1, v2]
    end

    address[i] = "."
  end

  actual_addresses.map { |v| v.to_i(2) }
end

def solve_part2(input)
  mem = {}
  current_mask = nil

  input.each do |line|
    if line.start_with?("mask")
      current_mask = parse_mask(line)
      next
    else
      address, value = parse_memory_write(line)

      apply_mask(current_mask, address).each do |actual_address|
        mem[actual_address] = value
      end
    end
  end

  mem.values.sum
end

# p solve_part2(input)
# => 4200656704538
# p solve_part2(input) == 4200656704538
