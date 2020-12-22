input = File.readlines("19.input.txt", "\n\n", chomp: true)

rules = input[0].split("\n").map do |r|
  number, rule = r.split(": ")

  rule.tr!("\"", "")

  [number, rule]
end.to_h

messages = input[1].split("\n")

# rules = [
#   "0: 4 1 5",
#   "1: 2 3 | 3 2",
#   "2: 4 4 | 5 5",
#   "3: 4 5 | 5 4",
#   '4: "a"',
#   '5: "b"',
# ].map do |r|
#   number, rule = r.split(": ")

#   rule.tr!("\"", "")

#   [number, rule]
# end.to_h

def build_rule(n, rules)
  if rules[n] !~ /\d+/
    return(
      if %w(a b).include?(rules[n])
        rules[n]
      elsif rules[n].include?("|")
        "(#{rules[n].tr(" ", "")})"
      else
        rules[n].tr(" ", "")
      end
    )
  end

  rules[n].gsub(/\d+/) do |m|
    r = build_rule(m, rules)

    if r.include?("|")
      "(#{r.tr(" ", "")})"
    else
      r.tr(" ", "")
    end
  end.tr(" ", "")
end

# === part 1

def solve_part1(rules, messages)
  rule_zero = /\A#{build_rule("0", rules)}\z/

  messages.count do |message|
    message =~ rule_zero
  end
end

# p solve_part1(rules, messages)
# p solve_part1(rules, messages) == 126

# === part 2

# rules["8"] = "42 | 42 8"
rules["8"] = "42 | 42 42 | 42 42 42 | 42 42 42 42 | 42 42 42 42 42"
# rules["11"] = "42 31 | 42 11 31"
rules["11"] = "42 31 | 42 42 31 31 | 42 42 42 31 31 31 | 42 42 42 42 31 31 31 31 | 42 42 42 42 42 31 31 31 31 31"

def solve_part2(rules, messages)
  solve_part1(rules, messages)
end

# p solve_part2(rules, messages)
# p solve_part2(rules, messages) == 282
