input = File.readlines("16.input.txt", "\n\n", chomp: true)

rules = input[0].split("\n").map do |l|
  field, ranges = l.split(": ")

  [
    field,
    ranges.split(" or ").map { |v| v.split("-").map(&:to_i) },
  ]
end

my_ticket = input[1].split("\n")[1].split(",").map(&:to_i)
nearby_tickets = input[2].split("\n").drop(1).map { |l| l.split(",").map(&:to_i) }

# === part 1

def completely_invalid?(value, rules)
  rules.all? do |(field, ranges)|
    ranges.all? do |(min, max)|
      value < min || value > max
    end
  end
end

def solve_part1(rules, nearby_tickets)
  error_rate = 0

  nearby_tickets.each do |ticket|
    ticket.each do |value|
      error_rate += value if completely_invalid?(value, rules)
    end
  end

  error_rate
end

# p solve_part1(rules, nearby_tickets)
# p solve_part1(rules, nearby_tickets) == 28873

# === part 2

nearby_tickets = nearby_tickets.reject do |ticket|
  ticket.any? { |value| completely_invalid?(value, rules) }
end

def solve_part2(rules, nearby_tickets)
  order = rules.map { |r| [r.first, []] }.to_h

  nearby_tickets.each do |ticket|
    ticket.each.with_index do |value, i|
      rules.each do |(field, ranges)|
        if ranges.any? { |(min, max)| min <= value && value <= max }
          order[field] << i
        end
      end
    end
  end

  order.transform_values! { |v| foo = v.tally; foo.select { |a,b| b == 190 } }

  order.each { |x| p x }
end

# p solve_part2(rules, nearby_tickets)
# Output:
#
# ["departure location", {6=>190, 7=>190, 10=>190, 11=>190, 16=>190, 18=>190, 19=>190}]
# ["departure station", {0=>190, 1=>190, 5=>190, 6=>190, 7=>190, 9=>190, 10=>190, 11=>190, 12=>190, 16=>190, 18=>190, 19=>190}]
# ["departure platform", {0=>190, 5=>190, 6=>190, 7=>190, 9=>190, 10=>190, 11=>190, 16=>190, 18=>190, 19=>190}]
# ["departure track", {0=>190, 6=>190, 7=>190, 9=>190, 10=>190, 11=>190, 16=>190, 18=>190, 19=>190}]
# ["departure date", {0=>190, 6=>190, 7=>190, 10=>190, 11=>190, 16=>190, 18=>190, 19=>190}]
# ["departure time", {0=>190, 1=>190, 5=>190, 6=>190, 7=>190, 9=>190, 10=>190, 11=>190, 16=>190, 18=>190, 19=>190}]
# ["arrival location", {0=>190, 1=>190, 2=>190, 3=>190, 5=>190, 6=>190, 7=>190, 9=>190, 10=>190, 11=>190, 12=>190, 13=>190, 14=>190, 16=>190, 17=>190, 18=>190, 19=>190}]
# ["arrival station", {6=>190, 7=>190, 10=>190, 11=>190, 16=>190, 18=>190}]
# ["arrival platform", {6=>190, 7=>190, 10=>190, 18=>190}]
# ["arrival track", {0=>190, 1=>190, 3=>190, 5=>190, 6=>190, 7=>190, 9=>190, 10=>190, 11=>190, 12=>190, 14=>190, 16=>190, 18=>190, 19=>190}]
# ["class", {0=>190, 1=>190, 3=>190, 5=>190, 6=>190, 7=>190, 9=>190, 10=>190, 11=>190, 12=>190, 16=>190, 18=>190, 19=>190}]
# ["duration", {18=>190}]
# ["price", {0=>190, 1=>190, 2=>190, 3=>190, 4=>190, 5=>190, 6=>190, 7=>190, 8=>190, 9=>190, 10=>190, 11=>190, 12=>190, 13=>190, 14=>190, 16=>190, 17=>190, 18=>190, 19=>190}]
# ["route", {0=>190, 1=>190, 2=>190, 3=>190, 5=>190, 6=>190, 7=>190, 9=>190, 10=>190, 11=>190, 12=>190, 13=>190, 14=>190, 16=>190, 18=>190, 19=>190}]
# ["row", {7=>190, 18=>190}]
# ["seat", {6=>190, 7=>190, 10=>190, 16=>190, 18=>190}]
# ["train", {6=>190, 7=>190, 18=>190}]
# ["type", {0=>190, 1=>190, 2=>190, 3=>190, 5=>190, 6=>190, 7=>190, 8=>190, 9=>190, 10=>190, 11=>190, 12=>190, 13=>190, 14=>190, 16=>190, 17=>190, 18=>190, 19=>190}]
# ["wagon", {0=>190, 1=>190, 2=>190, 3=>190, 4=>190, 5=>190, 6=>190, 7=>190, 8=>190, 9=>190, 10=>190, 11=>190, 12=>190, 13=>190, 14=>190, 15=>190, 16=>190, 17=>190, 18=>190, 19=>190}]
# ["zone", {0=>190, 1=>190, 3=>190, 5=>190, 6=>190, 7=>190, 9=>190, 10=>190, 11=>190, 12=>190, 13=>190, 14=>190, 16=>190, 18=>190, 19=>190}]
#
# Get the above output and manually reduce to:
#
# ["departure date",     {0=>190}]
# ["departure time",     {1=>190}]
# ["route",              {2=>190}]
# ["class",              {3=>190}]
# ["price",              {4=>190}]
# ["departure platform", {5=>190}]
# ["train",              {6=>190}]
# ["row",                {7=>190}]
# ["type",               {8=>190}]
# ["departure track",    {9=>190}]
# ["arrival platform",   {10=>190}]
# ["arrival station",    {11=>190}]
# ["departure station",  {12=>190}]
# ["zone",               {13=>190}]
# ["arrival track",      {14=>190}]
# ["wagon",              {15=>190}]
# ["seat",               {16=>190}]
# ["arrival location",   {17=>190}]
# ["duration",           {18=>190}]
# ["departure location", {19=>190}]
#

# p my_ticket.values_at(0, 1, 5, 9, 12, 19)
# p my_ticket.values_at(0, 1, 5, 9, 12, 19).reduce(:*) == 2587271823407
