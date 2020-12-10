input = File.readlines("10.input.txt", chomp: true).map(&:to_i).sort

# === part 1

def solve_part1(input)
  distribution = [0, 0, 1]

  ([0] + input).each_cons(2) do |a, b|
    # p(b - a - 1)
    distribution[b - a - 1] += 1
  end

  distribution[0] * distribution[2]
end

# p solve_part1(input)
# => 1917


# === part 2

def count_arrangements(input, i, memo)
  x = input[i]

  if x == input.last
    return 1
  end

  return memo[i] if memo[i]
  memo_i = 0

  a = input[i + 1]
  if a && a - x <= 3
    memo_i += count_arrangements(input, i + 1, memo)
  end

  b = input[i + 2]
  if b && b - x <= 3
    memo_i += count_arrangements(input, i + 2, memo)
  end

  c = input[i + 3]
  if c && c - x <= 3
    memo_i += count_arrangements(input, i + 3, memo)
  end

  memo[i] = memo_i
end

def solve_part2(input)
  count_arrangements([0] + input, 0, [])
end

# p solve_part2(input)
# => 113387824750592
