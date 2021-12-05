example_input = File.read("05.example-input.txt")
input = File.read("05.input.txt")

# === part 1

solve(input_to_line_segments(example_input).reject(&:diagonal?))
# => 5

solve(input_to_line_segments(input).reject(&:diagonal?))
# => 6397

# === part 2

solve(input_to_line_segments(example_input))
# => 12

solve(input_to_line_segments(input))
# => 22335

# === helpers

def solve(line_segments)
  tally = Hash.new(0)

  line_segments.each do |line_segment|
    line_segment.each { |point| tally[point] += 1 }
  end

  tally.count { |_point, line_segment_belongings| line_segment_belongings > 1 }
end

def input_to_line_segments(input)
  input.lines(chomp: true).map do |line|
    endpoints = line.split(" -> ").map do |coordinates|
      coordinates.split(",").map(&:to_i)
    end

    LineSegment.new(endpoints)
  end
end

class LineSegment
  include Enumerable

  Point = Struct.new(:x, :y)

  def initialize(endpoints)
    @a, @b = endpoints.map { |x, y| Point.new(x, y) }
  end

  def each
    step_x = vertical? ? 0 : (@a.x > @b.x ? -1 : 1)
    step_y = horizontal? ? 0 : (@a.y > @b.y ? -1 : 1)

    current_point = @a

    while current_point != @b
      yield current_point
      current_point = Point.new(
        current_point.x + step_x,
        current_point.y + step_y
      )
    end

    yield @b
  end

  def diagonal?
    !horizontal? && !vertical?
  end

  private

  def horizontal?
    @a.y == @b.y
  end

  def vertical?
    @a.x == @b.x
  end
end
