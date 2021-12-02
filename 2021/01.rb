input = File.readlines("01.input.txt", chomp: true)
input = input.map(&:to_i)

# === part 1

def solve_part_1(measurements)
  measurements
    .each_cons(2)
    .count { |m1, m2| m1 < m2 }
end

solve_part_1(input)
# => 1316

# === part 2

def solve_part_2(measurements)
  measurements
    .each_cons(3)
    .map(&:sum)
    .each_cons(2)
    .count { |s1, s2| s1 < s2 }
end

solve_part_2(input)
# => 1344
