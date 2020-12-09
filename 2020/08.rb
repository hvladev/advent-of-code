require "set"

input = File.readlines("08.input.txt", chomp: true)

instructions = input

# === part 1

def execute(instructions)
  current_line = 0
  executed = Set.new
  accumulator = 0

  loop do
    break if executed.include?(current_line)

    instruction, argument = instructions[current_line].split
    argument = argument.to_i

    executed << current_line
    # p [current_line, instruction, argument]

    case instruction
    when "acc"
      accumulator += argument
      current_line += 1
    when "nop"
      current_line += 1
    when "jmp"
      current_line += argument
    else
      raise "Unknown instruction: #{instruction}"
    end
  end

  accumulator
end

execute(instructions)
# => 1600


# === part 2

class OneInfiniteLoop < StandardError; end

def execute(instructions)
  current_line = 0
  executed = Set.new
  accumulator = 0

  loop do
    raise OneInfiniteLoop if executed.include?(current_line)
    break if instructions[current_line].nil?

    instruction, argument = instructions[current_line].split
    argument = argument.to_i

    executed << current_line
    # p [current_line, instruction, argument]

    case instruction
    when "acc"
      accumulator += argument
      current_line += 1
    when "nop"
      current_line += 1
    when "jmp"
      current_line += argument
    else
      raise "Unknown instruction: #{instruction}"
    end
  end

  accumulator
end

def fix_by_changing_exactly_one(instruction_type, instructions)
  answer = nil

  instructions.each_with_index do |instruction, i|
    if instruction.start_with?(instruction_type)

      fixed_instructions = instructions.dup
      fixed_instructions[i] = instruction.gsub("jmp", "nop")

      answer = execute(fixed_instructions)
      break
    end
  rescue OneInfiniteLoop
    next
  end

  answer
end

fix_attempts = [
  fix_by_changing_exactly_one("jmp", instructions),
  fix_by_changing_exactly_one("nop", instructions),
]

fix_attempts.compact.first
# => 1543
