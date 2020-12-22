input = File.readlines("21.input.txt", chomp: true)

# input = [
#   "mxmxvkd kfcds sqjhc nhms (contains dairy, fish)",
#   "trh fvjkl sbzzf mxmxvkd (contains dairy)",
#   "sqjhc fvjkl (contains soy)",
#   "sqjhc mxmxvkd sbzzf (contains fish)",
# ]

Food = Struct.new :ingredients, :ingredients_count, :allergens, :allergens_count

foods = input.map do |line|
  ingredients, allergens = line.match(/(.*?) \(contains (.*?)\)/).captures
  ingredients = ingredients.split(" ")
  allergens = allergens.split(", ")

  Food.new(ingredients, ingredients.count, allergens, allergens.count)
end

# === part 1

def solve_part1(foods)
  allergens_to_ingridients = {
    "eggs" => "cltx",
    "shellfish" => "tfqsb",
    "peanuts" => "tsqpn",
    "dairy" => "rcqb",
    "sesame" => "xhnk",
    "fish" => "nrl",
    "nuts" => "qjvvcvz",
    "wheat" => "zqzmzl",
  }

  food = foods.find do |food|
    food.allergens.count { |a| allergens_to_ingridients[a].nil? } == 1
  end

  while food do
    allergen = food.allergens.find { |a| allergens_to_ingridients[a].nil? }
    p food
    p " --- "
    p allergen
    p " --- "
    p allergens_to_ingridients
    p " --- "
    p " --- "
    p " --- "
    ingredients = foods
      .select { |f| f.allergens.include?(allergen) }
      .map do |f|
        f.ingredients.reject { |i| allergens_to_ingridients.values.include?(i) }
      end
      .reduce(:&)

    # raise "OMG: #{ingredients}" if ingredients.count != 1

    allergens_to_ingridients[allergen] = ingredients#.first

    p allergens_to_ingridients

    food = foods.find do |food|
      food.allergens.count { |a| allergens_to_ingridients[a].nil? } == 1
    end
  end

  foods.flat_map(&:ingredients).count { |i| !allergens_to_ingridients.values.include?(i) }
end

# p solve_part1(foods)
# p solve_part1(foods) == 2659


# === part 2

# from part 1
allergens_to_ingridients = {
  "dairy" => "rcqb",
  "eggs" => "cltx",
  "fish" => "nrl",
  "nuts" => "qjvvcvz",
  "peanuts" => "tsqpn",
  "sesame" => "xhnk",
  "shellfish" => "tfqsb",
  "wheat" => "zqzmzl",
}

def solve_part2(allergens_to_ingridients)
  allergens_to_ingridients
    .sort_by { |k, _v| k }
    .map { |pair| pair[1] }
    .join(",")
end

# p solve_part2(allergens_to_ingridients)
# p solve_part2(allergens_to_ingridients) == "rcqb,cltx,nrl,qjvvcvz,tsqpn,xhnk,tfqsb,zqzmzl"
