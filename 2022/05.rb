def parse_input
  stacks, procedure = File.read("05.input.txt").split("\n\n")

  stacks = stacks.split("\n")[0..-2]
  stacks = [1, 5, 9, 13, 17, 21, 25, 29, 33].map do |i|
    stacks.filter_map { _1[i] if _1[i] != " " }.reverse
  end

  procedure = procedure.split("\n").map { _1.scan(/\d+/).map(&:to_i) }

  [stacks, procedure]
end

module PartOne
  def self.solve(stacks, procedure)
    procedure.each do |quantity, from_stack, to_stack|
      quantity.times do
        crate = stacks[from_stack - 1].pop
        stacks[to_stack - 1].push(crate)
      end
    end

    stacks.map(&:last).join
  end
end

module PartTwo
  def self.solve(stacks, procedure)
    procedure.each do |quantity, from_stack, to_stack|
      crate = stacks[from_stack - 1].pop(quantity)
      stacks[to_stack - 1].concat(crate)
    end

    stacks.map(&:last).join
  end
end

p PartOne.solve(*parse_input)
# => FWNSHLDNZ

p PartTwo.solve(*parse_input)
# => RNRGDNFQG
