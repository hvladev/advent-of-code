input = File.readlines("18.input.txt", chomp: true)

# === part 1


def eval_simple(e)
  terms = e.split(" ")

  while terms.count > 1 do
    left, op, right = terms.shift(3)

    terms.prepend(
      case op
      when "+" then left.to_i + right.to_i
      when "*" then left.to_i * right.to_i
      end
    )
  end

  terms.first
end

def evaluate(expression)
  while expression.include?("(") do
    expression = expression.gsub(/\(([0-9+* ]+)\)/) do |e|
      eval_simple($1)
    end
  end

  eval_simple(expression)
end

def solve_part1(input)
  input.map { |e| evaluate(e) }.sum
end

# {
#   "1 + 2 * 3 + 4 * 5 + 6" => 71,
#   "2 * 3 + (4 * 5)" => 26,
#   "5 + (8 * 3 + 9 + 3 * 4 * 3)" => 437,
#   "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))" => 12240,
#   "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2" => 13632,
# }.map do |k,v|
#   p evaluate(k) == v
# end

# p solve_part1(input)
# p solve_part1(input) == 21993583522852

# === part 2

def eval_simple(e)
  if !e.include?("*") || !e.include?("+")
    return eval(e)
  end

  while e.include?("+") do
    e = e.gsub(/\d+ \+ \d+/) do |m|
      eval(m)
    end
  end

  eval(e)
end

def solve_part2(input)
  input.map { |e| evaluate(e) }.sum
end

# {
#   "1 + 2 * 3 + 4 * 5 + 6" => 231,
#   "1 + (2 * 3) + (4 * (5 + 6))" => 51,
#   "2 * 3 + (4 * 5)" => 46,
#   "5 + (8 * 3 + 9 + 3 * 4 * 3)" => 1445,
#   "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))" => 669060,
#   "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2" => 23340,
# }.map do |k,v|
#   p evaluate(k) == v
# end

# p solve_part2(input)
# p solve_part2(input) == 122438593522757
