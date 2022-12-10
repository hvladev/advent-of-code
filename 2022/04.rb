lines = File.readlines("04.input.txt", chomp: true)
pairs = lines.map do |line|
  line.split(",").map { Range.new(*_1.split("-").map(&:to_i)) }
end

module PartOne
  def self.solve(pairs)
    pairs.count { _1.cover?(_2) || _2.cover?(_1) }
  end
end

module PartTwo
  def self.solve(pairs)
    pairs.count do
      _1.include?(_2.begin) || _1.include?(_2.end) ||
        _2.include?(_1.begin) || _2.include?(_1.end)
    end
  end
end

p PartOne.solve(pairs)
# => 562

p PartTwo.solve(pairs)
# => 924
