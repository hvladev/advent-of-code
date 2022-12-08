lines = File.readlines("02.input.txt", chomp: true)

OUTCOMES = {
  [:rock, :scissors] => [:win, :loss],
  [:scissors, :rock] => [:loss, :win],
  [:rock, :rock] => [:draw, :draw],

  [:paper, :rock] => [:win, :loss],
  [:rock, :paper] => [:loss, :win],
  [:paper, :paper] => [:draw, :draw],

  [:scissors, :paper] => [:win, :loss],
  [:paper, :scissors] => [:loss, :win],
  [:scissors, :scissors] => [:draw, :draw]
}

SCORES = {
  rock: 1,
  paper: 2,
  scissors: 3,

  loss: 0,
  draw: 3,
  win: 6
}

module PartOne
  LETTER_TO_SHAPE = {
    "A" => :rock, "X" => :rock,
    "B" => :paper, "Y" => :paper,
    "C" => :scissors, "Z" => :scissors
  }

  def self.calculate_scores(p1_shape, p2_shape)
    p1_outcome, p2_outcome = OUTCOMES[[p1_shape, p2_shape]]

    {
      p1: SCORES[p1_shape] + SCORES[p1_outcome],
      p2: SCORES[p2_shape] + SCORES[p2_outcome]
    }
  end

  def self.solve(lines)
    rounds = lines.map { _1.split.map(&LETTER_TO_SHAPE) }
    scores = rounds.map { calculate_scores(*_1) }

    scores.sum { _1[:p2] }
  end
end

p PartOne.solve(lines)
# => 14531

# === part 2

module PartTwo
  LETTER_TO_SHAPE = {
    "A" => :rock,
    "B" => :paper,
    "C" => :scissors,

    "X" => :loss,
    "Y" => :draw,
    "Z" => :win
  }

  def self.calculate_scores(p1_shape, p2_outcome)
    shapes, outcomes = OUTCOMES.find do |shapes, outcomes|
      shapes[0] == p1_shape && outcomes[1] == p2_outcome
    end
    p2_shape = shapes[1]
    p1_outcome = outcomes[0]

    {
      p1: SCORES[p1_shape] + SCORES[p1_outcome],
      p2: SCORES[p2_shape] + SCORES[p2_outcome]
    }
  end

  def self.solve(lines)
    rounds = lines.map { _1.split.map(&LETTER_TO_SHAPE) }
    scores = rounds.map { calculate_scores(*_1) }

    scores.sum { _1[:p2] }
  end
end

p PartTwo.solve(lines)
# => 11258
