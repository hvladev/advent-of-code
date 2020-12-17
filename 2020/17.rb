require "set"

input = File.readlines("17.input.txt", chomp: true)

def initial_active_cubes(input, dimensions_count:)
  active_cubes = Set.new

  input.each.with_index do |line, y|
    line.chars.each.with_index do |cube_state, x|
      active_cubes << [x, y, 0, 0].take(dimensions_count) if cube_state == "#"
    end
  end

  active_cubes
end

def execute_cycle(active_cubes)
  next_active_cubes = Set.new
  inactive_cubes = Set.new

  active_cubes.each do |coords|
    active_neighbors_count = 0

    neighbours_of(*coords).each do |n|
      if active_cubes.include?(n)
        active_neighbors_count += 1
      else
        inactive_cubes << n
      end
    end

    if active_neighbors_count == 2 || active_neighbors_count == 3
      next_active_cubes << coords
    end
  end

  inactive_cubes.each do |coords|
    active_neighbors_count = neighbours_of(*coords).count { |n| active_cubes.include?(n) }

    if active_neighbors_count == 3
      next_active_cubes << coords
    end
  end

  next_active_cubes
end

# === part 1

def neighbours_of(x, y, z)
  neighbours = []

  [-1, 0, 1].each do |dz|
    [-1, 0, 1].each do |dy|
      [-1, 0, 1].each do |dx|
        neighbours << [x + dx, y + dy, z + dz] unless [dx, dy, dz].all?(&:zero?)
      end
    end
  end

  neighbours
end

def solve_part1(input)
  active_cubes = initial_active_cubes(input, dimensions_count: 3)

  6.times do
    active_cubes = execute_cycle(active_cubes)
  end

  active_cubes.count
end

# p solve_part1(input)
# p solve_part1(input) == 263


# === part 2

def neighbours_of(x, y, z, w)
  neighbours = []

  [-1, 0, 1].each do |dw|
    [-1, 0, 1].each do |dz|
      [-1, 0, 1].each do |dy|
        [-1, 0, 1].each do |dx|
          neighbours << [x + dx, y + dy, z + dz, w + dw] unless [dx, dy, dz, dw].all?(&:zero?)
        end
      end
    end
  end

  neighbours
end

def solve_part2(input)
  active_cubes = initial_active_cubes(input, dimensions_count: 4)

  6.times do
    active_cubes = execute_cycle(active_cubes)
  end

  active_cubes.count
end

# p solve_part2(input)
# p solve_part2(input) == 1680
