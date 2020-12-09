input = File.readlines("01.input.txt", chomp: true).map(&:to_i)

# === part 1

a, b = input.combination(2).find { |(x, y)| x + y == 2020 }
a * b # => 776064

# === part 2

a, b, c = input.combination(3).find { |(x, y, z)| x + y + z == 2020 }
a * b * c # => 6964490
