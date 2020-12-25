input = File.readlines("23.input.txt", chomp: true)

cups = input.first.chars.map(&:to_i)

# cups = [3, 8, 9, 1, 2, 5, 4, 6, 7]

# === part 1

def solve_part1(cups)
  # initial setup
  current = cups.first
  cups_count = cups.count

  100.times do |i|
    # puts "--- move #{i + 1} ---"
    # puts "cups: #{cups.map { |c| c == current ? "(#{c})" : c }}"

    # pick up
    from = cups.index(current) + 1
    to = from + 2
    selection = cups.cycle(2).to_a[from..to]

    # puts "pick up: #{selection}"

    # cups except pick up
    cups_except_selection = cups.reject { |cup| selection.include?(cup) }

    # destination cup
    destination = cups_except_selection.select { |cup| cup < current }.max
    destination = cups_except_selection.max unless destination

    # puts "destination: #{destination}\n\n"

    # place pick up
    before, after = cups_except_selection.slice_after(destination).to_a
    cups = [before, selection, after].compact.flatten

    # current cup
    current = cups[(cups.index(current) + 1) % cups_count]
  end

  before, after = cups.slice_after(1).to_a
  [after, before[0..-2]].compact.flatten.join
end

# p solve_part1(cups)
# p solve_part1(cups) == "69425837"


# === part 2

Node = Struct.new(:value, :next, keyword_init: true) do
  def to_s
    "#{value} -> #{self.next.value}"
  end

  def inspect
    "#{value} -> #{self.next.value}"
  end
end

def solve_part2(cups)
  cups = cups + (10..1_000_000).to_a
  cups_count = 1_000_000

  # Create circular linked list from cups
  current_cup = Node.new(value: cups[0], next: nil)
  fast_access_by_value = {}
  fast_access_by_value[cups[0]] = current_cup

  i = 1
  node = current_cup
  while i < cups_count
    node.next = Node.new(value: cups[i], next: nil)
    node = node.next

    fast_access_by_value[cups[i]] = node

    i += 1
  end
  node.next = current_cup

  highest_value = 1_000_000
  10_000_000.times do |i|
    # The crab picks up the three cups
    selection = [
      current_cup.next.value,
      current_cup.next.next.value,
      current_cup.next.next.next.value,
    ]

    # The crab selects a destination cup
    destination_value = current_cup.value - 1
    destination_value = highest_value if destination_value.zero?
    while selection.include?(destination_value)
      destination_value -= 1
      destination_value = highest_value if destination_value.zero?
    end
    destination = fast_access_by_value[destination_value]

    # The crab places the picked up cups after the destination cup
    selection_next = destination.next
    destination.next = current_cup.next
    current_cup.next = current_cup.next.next.next.next
    destination.next.next.next.next = selection_next

    # The crab selects a new current cup
    current_cup = current_cup.next
  end

  cup_uno = fast_access_by_value[1]
  cup_uno.next.value * cup_uno.next.next.value
end

# p solve_part2(cups)
p solve_part2(cups) == 218882971435
