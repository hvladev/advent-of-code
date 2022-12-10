require "set"

lines = File.readlines("09.input.txt", chomp: true)
motions = lines.map(&:split).map { [_1, _2.to_i] }

def count_positions_visited_by_tail(rope, motions)
  head = rope[0]
  tail = rope[-1]
  tail_visited = Set.new << tail.dup

  motions.each do |direction, steps|
    steps.times do
      case direction
      in "U" then head[1] += 1
      in "R" then head[0] += 1
      in "D" then head[1] -= 1
      in "L" then head[0] -= 1
      end

      rope.each_cons(2) do |knot1, knot2|
        dx = knot1[0] - knot2[0]
        dy = knot1[1] - knot2[1]

        break if dx.abs != 2 && dy.abs != 2

        knot2[0] += knot1[0] <=> knot2[0]
        knot2[1] += knot1[1] <=> knot2[1]
      end

      tail_visited << tail.dup
    end
  end

  tail_visited.count
end

module PartOne
  def self.solve(motions)
    rope = Array.new(2) { [0, 0] }

    count_positions_visited_by_tail(rope, motions)
  end
end

module PartTwo
  def self.solve(motions)
    rope = Array.new(10) { [0, 0] }

    count_positions_visited_by_tail(rope, motions)
  end
end

p PartOne.solve(motions)
# => 5513

p PartTwo.solve(motions)
# => 2427
