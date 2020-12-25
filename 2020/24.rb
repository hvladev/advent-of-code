input = File.readlines("24.input.txt", chomp: true)

# six neighbors: east, southeast, southwest, west, northwest, and northeast
# directions:    e,    se,        sw,        w,    nw,        and ne

def parse_directions(text)
  directions = []
  i = 0
  text_length = text.length

  while i < text_length
    if text[i] == "e" || text[i] == "w"
      directions << text[i]
      i += 1
    else
      directions << text[i..(i + 1)]
      i += 2
    end
  end

  directions
end

def flip(input)
  flipped = {}

  input.each do |line|
    directions = parse_directions(line)
    x, y = 0, 0

    directions.each do |direction|
      case direction
      when "e"
        x += 1
      when "se"
        x += 1 if y.odd?
        y -= 1
      when "sw"
        x -= 1 if y.even?
        y -= 1
      when "w"
        x -= 1
      when "nw"
        x -= 1 if y.even?
        y += 1
      when "ne"
        x += 1 if y.odd?
        y += 1
      end
    end

    position = [x, y]

    if flipped[position]
      flipped[position] += 1
    else
      flipped[position] = 1
    end
  end

  flipped
end

# === part 1

def solve_part1(input)
  flip(input).count { |_k, v| v.odd? }
end

# p solve_part1(input)
# p solve_part1(input) == 373


# === part 2

require "set"

def adjacent_tiles(tile)
  x, y = tile

  %w(e se sw w nw ne).map do |direction|
    case direction
    when "e"
      [x + 1, y]
    when "se"
      [(y.odd? ? x + 1 : x), y - 1]
    when "sw"
      [(y.even? ? x - 1 : x), y - 1]
    when "w"
      [x - 1, y]
    when "nw"
      [(y.even? ? x - 1 : x), y + 1]
    when "ne"
      [(y.odd? ? x + 1 : x), y + 1]
    end
  end
end

def solve_part2(input)
  black_tiles = flip(input).select { |_k, v| v.odd? }.keys.to_set

  100.times do |i|
    next_black_tiles = Set.new
    white_tiles = {}

    black_tiles.each do |tile|
      adj_black_tiles, adj_white_tiles =
        adjacent_tiles(tile).partition { |at| black_tiles.include?(at) }

      adj_black_tiles_count = adj_black_tiles.count
      if adj_black_tiles_count > 0 && adj_black_tiles_count <= 2
        next_black_tiles << tile
      end

      adj_white_tiles.each do |adj_white_tile|
        if white_tiles[adj_white_tile]
          white_tiles[adj_white_tile] += 1
        else
          white_tiles[adj_white_tile] = 1
        end
      end
    end

    white_tiles.each do |tile, adj_black_tiles_count|
      next_black_tiles << tile if adj_black_tiles_count == 2
    end

    black_tiles = next_black_tiles
    # puts "Day #{i + 1}: #{black_tiles.count}"
  end

  black_tiles.count
end

# p solve_part2(input)
# p solve_part2(input) == 3917
