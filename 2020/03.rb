input = File.readlines("03.input.txt", chomp: true)

h = input.size                 # => 323 (0, 321)
line_length = input[0].size    # => 31  (0, 30)

# === part 1

#  0 -> 0, 0
#  1 -> 3, 1
#  2 -> 6, 2
#  3 -> 9, 3
# ...
#  9 -> 27, 9
# 10 -> 30, 10    i -> (i * 3, i)
# 11 -> 2, 11

# 11 % 31

trees = 0
input.each.with_index do |line, i|
  trees += 1 if line[(i * 3) % line_length] == "#"
end
trees # => 274

# "......#..##..#...#...#.###....."
# "...!..#..##..#...#...#.###....."
# "......!..##..#...#...#.###....."
# "......#..!#..#...#...#.###....."
# "......#..##.!#...#...#.###....."
# "......#..##..#.!.#...#.###....."
# "......#..##..#...#!..#.###....."
# "......#..##..#...#...!.###....."
# "......#..##..#...#...#.#!#....."
# "......#..##..#...#...#.###.!..."
# "......#..##..#...#...#.###....!"
#                                "..!...#..##..#...#...#.###....."

# === part 2

# Right 1, down 1.
# Right 3, down 1. (This is the slope you already checked.)
# Right 5, down 1.
# Right 7, down 1.
# Right 1, down 2.

input = File.readlines("example.txt", chomp: true)
line_length = input[0].size    # => 31  (0, 30)

slopes = [
  [1, 1],
  [3, 1],
  [5, 1],
  [7, 1],
  [1, 2],
]

# does NOT work for the last slop [1, 2]
def trees_on_slope(input, line_length, slope)
  x, y = slope
  n = 0

  input.each.with_index do |line, i|
    next if i % y != 0
    n += 1 if line[(i * x) % line_length] == "#"
  end

  n
end

slopes.map { |slope| trees_on_slope(input, line_length, slope) }
# => [90, 274, 82, 68, 50]
#                      ^ WRONG


# HACK to calculate last slope [1, 2]

input = File.readlines("03.input.txt", chomp: true)
line_length = input[0].size    # => 31  (0, 30)

n = 0

input.each.with_index do |line, i|
  next if i % 2 != 0
  n += 1 if line[((i / 2) % line_length)] == "#"
end

n # => 44

#   0    ..##....... 0
#   1    #...#...#.. skip
#   2    .X....#..#. 1
#   3    ..#.#...#.# skip
#   4    .#O..##..#. 2
#   5    ..#.##..... skip
#   6    .#.X.#....# 3
#   7    .#........# skip
#   8    #.##O..#... 4
#   9    #...##....# skip
#  10    .#..#O..#.# 5


# FINAL ANSWER of part 2
# => [90, 274, 82, 68, 50].reduce(:*)
# => 6050183040
