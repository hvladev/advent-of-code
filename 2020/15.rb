input = File.readlines("15.input.txt", chomp: true)
input = input.first.split(",").map(&:to_i)

# === part 1

def solve_part1(input, nth_number = 2020)
  current_turn = 0
  short_memory = []
  long_memory = []
  last_spoken_number = nil

  input.each do |x|
    current_turn += 1
    last_spoken_number = x

    short_memory[last_spoken_number] = current_turn
  end

  while current_turn < nth_number do
    current_turn += 1

    last_spoken_number =
      if long_memory[last_spoken_number]
        short_memory[last_spoken_number] - long_memory[last_spoken_number]
      else
        0
      end

    long_memory[last_spoken_number] = short_memory[last_spoken_number]
    short_memory[last_spoken_number] = current_turn
  end

  last_spoken_number
end

# p solve_part1([0,3,6]) == 436
# p solve_part1([1,3,2]) == 1
# p solve_part1([2,1,3]) == 10
# p solve_part1([1,2,3]) == 27
# p solve_part1([2,3,1]) == 78
# p solve_part1([3,2,1]) == 438
# p solve_part1([3,1,2]) == 1836

# p solve_part1(input)
# p solve_part1(input) == 421


# === part 2

def solve_part2(input)
  solve_part1(input, 30_000_000)
end

# p solve_part2(input)
# p solve_part2(input) == 436
