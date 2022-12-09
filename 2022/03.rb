lines = File.readlines("03.input.txt", chomp: true)

TYPE_TO_PRIORITY = (("a".."z").to_a + ("A".."Z").to_a)
  .map.with_index { |type, index| [type, index + 1] }
  .to_h

module PartOne
  extend self

  def common_item_type(items)
    chars = items.chars
    half_length = chars.length / 2
    first_half = chars.take(half_length)
    second_half = chars.drop(half_length)

    (first_half & second_half).first
  end

  def solve(lines)
    lines.map { TYPE_TO_PRIORITY[common_item_type(_1)] }.sum
  end
end

p PartOne.solve(lines)
# => 8053

module PartTwo
  extend self

  def common_item_type(group)
    group.map(&:chars).reduce(:&).first
  end

  def solve(lines)
    lines.each_slice(3).map { TYPE_TO_PRIORITY[common_item_type(_1)] }.sum
  end
end

p PartTwo.solve(lines)
# => 2425
