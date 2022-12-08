input = File.read("01.input.txt")

total_calories_per_elf =
  input.split("\n\n").map { _1.split("\n").map(&:to_i).sum }

# === part 1

def solve_part1(total_calories_per_elf)
  total_calories_per_elf.max
end

p solve_part1(total_calories_per_elf)
# => 64929

# === part 2

def solve_part2(total_calories_per_elf)
  total_calories_per_elf.max(3).sum
end

p solve_part2(total_calories_per_elf)
# => 193697
