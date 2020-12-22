input = File.readlines("20.input.txt", "\n\n", chomp: true)

tiles = input.map do |tile|
  id, *image = tile.split("\n")

  id = id.match(/\d+/)[0].to_i

  top = image[0]
  bottom = image[-1]

  left = image.map { |i| i[0] }.join
  right = image.map { |i| i[-1] }.join

  {
    id: id,
    image: image,
    borders: {
      top => :top,
      top.reverse => :top_reverse,
      bottom => :bottom,
      bottom.reverse => :bottom_reverse,
      left => :left,
      left.reverse => :left_reverse,
      right => :right,
      right.reverse => :right_reverse,
    },
  }
end

# === part 1

def solve_part1(tiles)
  corner_tiles = []

  tiles.each do |tile|
    matching_borders_count = 0

    tiles.each do |t|
      next if tile[:id] == t[:id]

      if (tile[:borders].keys & t[:borders].keys).count > 0
        matching_borders_count += 1
      end
    end

    corner_tiles << tile if matching_borders_count == 2
  end

  corner_tiles.map { |t| t[:id] }.reduce(:*)
end

# p solve_part1(tiles)
# p solve_part1(tiles) == 28057939502729


# === part 2

# These are the IDs of the corner tiles from part 1:
#
#   [3023, 1571, 1709, 3457]
#
# Let's pick one of them and start building the whole image.

# corner_tile_id = 3023
# corner_tile = tiles.find { |t| t[:id] == corner_tile_id }

class Tile
  attr_reader :id

  def initialize(id:, pixels:)
    @id = id
    @pixels = pixels
    @adjacent_tiles = {
      top: nil,
      right: nil,
      bottom: nil,
      left: nil,
    }
  end

  def without_border
    @pixels.map { |row| row[1..-2] }[1..-2]
  end

  def fixed?
    @adjacent_tiles.values.compact.count > 0
  end

  def borders
    %i(top right bottom left).map { |direction| border(direction) }
  end

  def possible_borders
    [
      @pixels[0],
      @pixels[0].reverse,
      @pixels.map { |i| i[-1] },
      @pixels.map { |i| i[-1] }.reverse,
      @pixels[-1],
      @pixels[-1].reverse,
      @pixels.map { |i| i[0] },
      @pixels.map { |i| i[0] }.reverse,
    ]
  end

  def border(direction)
    case direction
    when :top then @pixels[0]
    when :right then @pixels.map { |i| i[-1] }
    when :bottom then @pixels[-1]
    when :left then @pixels.map { |i| i[0] }
    end
  end

  def rotate
    @pixels = @pixels.reverse.transpose
  end

  def flip
    @pixels = @pixels.reverse
  end

  def to_s
    "Tile #{@id}:\n#{@pixels.map(&:join).join("\n")}"
  end

  def []=(direction, tile)
    @adjacent_tiles[direction] = tile
  end

  def [](direction)
    @adjacent_tiles.fetch(direction)
  end
end

def matching_borders(tile, other_tile)
  if tile.border(:top) == other_tile.border(:bottom)
    [:top, :bottom]
  elsif tile.border(:right) == other_tile.border(:left)
    [:right, :left]
  elsif tile.border(:bottom) == other_tile.border(:top)
    [:bottom, :top]
  elsif tile.border(:left) == other_tile.border(:right)
    [:left, :right]
  else
    [nil, nil]
  end
end

def assemble_image(input)
  tiles = input.map do |tile|
    line_with_id, *image_data = tile.split("\n")

    id = line_with_id.match(/\d+/)[0].to_i
    pixels = image_data.map(&:chars)

    [id, Tile.new(id: id, pixels: pixels)]
  end.to_h

  ids = tiles.keys

  until ids.empty? do
    fixed_tile_id = ids.find { |id| tiles[id].fixed? }
    tile =
      if fixed_tile_id
        ids.delete(fixed_tile_id)
        tiles[fixed_tile_id]
      else
        tiles[ids.shift]
      end

    ids.each do |id|
      other_tile = tiles[id]
      matching_borders_count = (tile.borders & other_tile.possible_borders).count

      next if matching_borders_count.zero?

      tile_border, other_tile_border = nil, nil

      8.times do |i|
        other_tile.flip if i == 4

        tile_border, other_tile_border = matching_borders(tile, other_tile)

        break if other_tile.fixed? || tile_border

        other_tile.rotate
      end

      if tile_border
        tile[tile_border] = other_tile
        other_tile[other_tile_border] = tile
      end
    end
  end

  top_left_tile = tiles.find { |id, t| t[:top] == nil && t[:left] == nil }[1]
  start_tile = top_left_tile
  rows = []

  while start_tile do
    rest = []
    current = start_tile

    loop do
      tile = current[:right]
      break unless tile

      rest << tile
      current = tile
    end

    rows +=
      start_tile.without_border.zip(*rest.map(&:without_border)).map(&:flatten)

    start_tile = start_tile[:bottom]
  end

  rows
end

image = assemble_image(input)

def count_sea_monsters(image)
  row_length = image.first.count
  sea_monster = [
    /..................#./,
    /#....##....##....###/,
    /.#..#..#..#..#..#.../,
  ]
  sea_monster_length = 20
  sea_monsters_count = 0

  (0..(image.size - 3)).each do |row|
    (0..(row_length - 1)).each do |column|

      if image[row + 0][column...(column + sea_monster_length)].join =~ sea_monster[0] &&
          image[row + 1][column...(column + sea_monster_length)].join =~ sea_monster[1] &&
          image[row + 2][column...(column + sea_monster_length)].join =~ sea_monster[2]
        sea_monsters_count += 1
      end
    end
  end

  sea_monsters_count
end

p count_sea_monsters(image)

# rotate
image = image.reverse.transpose
p count_sea_monsters(image)

# rotate
image = image.reverse.transpose
p count_sea_monsters(image)

# rotate
image = image.reverse.transpose
p count_sea_monsters(image)

# flip <-------
image = image.reverse
p count_sea_monsters(image)
sea_monsters_count = 18

# rotate
image = image.reverse.transpose
p count_sea_monsters(image)

# rotate
image = image.reverse.transpose
p count_sea_monsters(image)

# rotate
image = image.reverse.transpose
p count_sea_monsters(image)

per_monster = 15
p image.map(&:join).join.count("#") - (sea_monsters_count * per_monster)
# => 2489
