input = File.readlines("07.input.txt", chomp: true)

input[0]
input[0].match /(.*) bags contain no other bags\./
md = input[0].match /(.*) bags contain (.*)/
md[1]
md[2][0..-2].split(", ").map { |x| x.match(/\d+ (.*) bag/)[1] }


input[0]
parse_line(input[0])

input[5]
parse_line(input[5])

input[105]
parse_line(input[105])

input[147]
parse_line(input[147])

input[345]
parse_line(input[345])


# === part 1

def parse_line(line)
  md = line.match /(.*) bags contain no other bags\./

  if md
    [
      md[1],
      [],
    ]
  else
    md = line.match /(.*) bags contain (.*)/

    [
      md[1],
      md[2][0..-2].split(", ").map { |x| x.match(/\d+ (.*) bag/)[1] },
    ]
  end
end

def may_contain_gold_bag?(bag, bags)
  return true if bags[bag].include?("shiny gold")
  return false if bags[bag].empty?

  bags[bag].any? { |b| may_contain_gold_bag?(b, bags) }
end

bags = {}
input.each do |l|
  k, v = parse_line(l)
  bags[k] = v
end

bags.keys.count { |bag| may_contain_gold_bag?(bag, bags) }
# => 144


# === part 2

def parse_line(line)
  md = line.match /(.*) bags contain no other bags\./

  if md
    [
      md[1],
      [],
    ]
  else
    md = line.match /(.*) bags contain (.*)/

    [
      md[1],
      md[2][0..-2].split(", ").map do |x|
        m = x.match(/(\d+) (.*) bag/)

        [m[1].to_i, m[2]]
      end,
    ]
  end
end

def number_of_bags_inside(bag, bags)
  return 0 if bags[bag].empty?

  bags[bag].map { |(x, b)| x + (x * number_of_bags_inside(b, bags)) }.reduce(:+)
end

bags = {}
input.each do |l|
  k, v = parse_line(l)
  bags[k] = v
end

number_of_bags_inside("shiny gold", bags)
# => 5956
