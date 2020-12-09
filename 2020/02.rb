input = File.readlines("02.input.txt", chomp: true)

# === part 1

def valid_password?(line)
  policy, password = line.split(":").map(&:strip)
  range_string, letter = policy.split(" ")
  range = Range.new(*range_string.split("-").map(&:to_i))

  range.include? password.count(letter)
end

input.count do |line|
  valid_password?(line)
end

# => 454


# === part 1

def valid_password?(line)
  policy, password = line.split(":").map(&:strip)
  positions, letter = policy.split(" ")
  i1, i2 = positions.split("-").map(&:to_i).map(&:pred)

  (password[i1] == letter && password[i2] != letter) ||
    (password[i1] != letter && password[i2] == letter)
end

input.count do |line|
  valid_password?(line)
end

# => 649
