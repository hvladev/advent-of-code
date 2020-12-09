input = File.readlines("04.input.txt", "\n\n", chomp: true)

required = %w(
  byr
  iyr
  eyr
  hgt
  hcl
  ecl
  pid
)
required_count = required.count

# === part 1

valid = 0
input.each do |p|
  foo = p.lines(chomp: true).map(&:split).flatten

  valid += 1 if foo.count { |x| x !~ /cid/ } == required_count
end
valid
# => 190


# === part 2

validations = {
  "byr" => -> (x) { x =~ /\A\d{4}\z/ && (1920..2002).include?(x.to_i) },
  "iyr" => -> (x) { x =~ /\A\d{4}\z/ && (2010..2020).include?(x.to_i) },
  "eyr" => -> (x) { x =~ /\A\d{4}\z/ && (2020..2030).include?(x.to_i) },
  "hgt" => lambda do |x|
    x =~ /\A\d+(cm|in)\z/

    ($1 == "cm" && (150..193).include?(x.to_i)) ||
      ($1 == "in" && (59..76).include?(x.to_i))
  end,
  "hcl" => -> (x) { (x =~ /\A#[0-9a-f]{6}\z/) == 0 },
  "ecl" => -> (x) { %w(amb blu brn gry grn hzl oth).include?(x) },
  "pid" => -> (x) { (x =~ /\A\d{9}\z/) == 0 },
}

valid = 0
input.each do |p|
  foo = p.lines(chomp: true).map(&:split).flatten
  fields = foo.map { |x| x.split(":") }.to_h
  valid_fields_count = fields.count { |(k, v)| k != "cid" && validations[k].call(v) }

  valid += 1 if valid_fields_count == required_count
end
valid

# => 121
