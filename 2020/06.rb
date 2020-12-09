input = File.readlines("06.input.txt", "\n\n", chomp: true)

# === part 1

groups = input.map { |g| g.gsub("\n", "") }

groups.sum { |group| group.chars.uniq.size }
# => 6763


# === part 2

groups = input.map { |g| g.split.map(&:chars) }

groups.sum { |group| group.reduce(&:intersection).count }
# => 3512
