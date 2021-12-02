input = File.readlines("02.input.txt", chomp: true)
input = input.map(&:split).map { |(a, b)| [a, b.to_i] }

# === part 1

def solve_part_1(instructions)
  horizontal_position = 0
  depth = 0

  instructions.each do |direction, units|
    case direction
    when "forward" then horizontal_position += units
    when "down" then depth += units
    when "up" then depth -= units
    end
  end

  horizontal_position * depth
end

solve_part_1(input)
# => 1815044

# === part 2

def solve_part_2(instructions)
  horizontal_position = 0
  depth = 0
  aim = 0

  instructions.each do |direction, units|
    case direction
    when "forward"
      horizontal_position += units
      depth += aim * units
    when "down"
      aim += units
    when "up"
      aim -= units
    end
  end

  horizontal_position * depth
end

solve_part_2(input)
# => 1739283308
