lines = File.readlines("10.input.txt", chomp: true)

Instruction = Struct.new(:type, :cycles, :value, keyword_init: true)

instructions = lines.map do |line|
  operation, value = line.split

  args =
    case operation
    in "noop" then {type: :noop, cycles: 1, value: nil}
    in "addx" then {type: :addx, cycles: 2, value: value.to_i}
    end

  Instruction.new(args)
end

def solve(instructions)
  cycle = 0
  register = 1
  sum = 0
  display = []

  instructions.each do |instruction|
    instruction.cycles.times do
      display[cycle] = (((cycle % 40) - register).abs <= 1) ? "#" : "."

      cycle += 1

      sum += cycle * register if [20, 60, 100, 140, 180, 220].include?(cycle)
    end

    register += instruction.value if instruction.type == :addx
  end

  [sum, display]
end

sum, display = solve(instructions)

p sum
# => 15140

puts display.each_slice(40).map(&:join)
# =>    ###..###....##..##..####..##...##..###..
# =>    #..#.#..#....#.#..#....#.#..#.#..#.#..#.
# =>    ###..#..#....#.#..#...#..#....#..#.#..#.
# =>    #..#.###.....#.####..#...#.##.####.###..
# =>    #..#.#....#..#.#..#.#....#..#.#..#.#....
# =>    ###..#.....##..#..#.####..###.#..#.#....
#
# => BPJAZGAP
