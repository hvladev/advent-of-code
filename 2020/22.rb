input = File.readlines("22.input.txt", "\n\n", chomp: true)

p1_deck = input[0].split("\n").drop(1).map(&:to_i)
p2_deck = input[1].split("\n").drop(1).map(&:to_i)

# p1_deck = [9, 2, 6, 3, 1]
# p2_deck = [5, 8, 4, 7, 10]

# p1_deck = [43, 19]
# p2_deck = [2, 29, 14]

def calculate_score(cards)
  cards.reverse.map.with_index { |card, i| card * (i + 1) }.sum
end

# === part 1

def solve_part1(p1_deck, p2_deck)
  until p1_deck.empty? || p2_deck.empty?
    p1_card = p1_deck.shift
    p2_card = p2_deck.shift

    if p1_card > p2_card
      p1_deck << p1_card
      p1_deck << p2_card
    else
      p2_deck << p2_card
      p2_deck << p1_card
    end
  end

  [calculate_score(p1_deck), calculate_score(p2_deck)].max
end

# p solve_part1(p1_deck, p2_deck)
# p solve_part1(p1_deck, p2_deck) == 32401


# === part 2

require "set"

def play_game(p1_deck, p2_deck, n)
  previous_rounds = Set.new

  # puts "=== Game #{n} ===\n\n"
  r = 1

  until p1_deck.empty? || p2_deck.empty?
    # puts "--- Round #{r} (Game #{n}) ---"
    # puts "p1 deck: #{p1_deck}"
    # puts "p2 deck: #{p2_deck}"

    if previous_rounds.include?([p1_deck, p2_deck])
      # puts "OMG"
      # p previous_rounds
      return {winner: :p1, score: calculate_score(p1_deck)}
    else
      previous_rounds << [p1_deck.dup, p2_deck.dup]
    end

    p1_card = p1_deck.shift
    p2_card = p2_deck.shift

    # puts "p1 plays: #{p1_card}"
    # puts "p2 plays: #{p2_card}"

    winner_of_the_round =
      if p1_deck.count >= p1_card && p2_deck.count >= p2_card
        play_game(p1_deck.take(p1_card), p2_deck.take(p2_card), n+1)[:winner]
      else
        p1_card > p2_card ? :p1 : :p2
      end

    # puts "#{winner_of_the_round} wins round #{r} of game #{n}!\n\n"

    case winner_of_the_round
    when :p1
      p1_deck << p1_card
      p1_deck << p2_card
    when :p2
      p2_deck << p2_card
      p2_deck << p1_card
    end

    r += 1
  end

  if p1_deck.empty?
    {winner: :p2, score: calculate_score(p2_deck)}
  else
    {winner: :p1, score: calculate_score(p1_deck)}
  end
end

p play_game(p1_deck, p2_deck, 1)
p play_game(p1_deck, p2_deck, 1)[:score] == 31436
