input = File.readlines("25.input.txt", chomp: true)

card_public_key = input[0].to_i
door_public_key = input[1].to_i

# card_public_key = 5764801
# door_public_key = 17807724

# === part 1

def execute_transformation_steps(value, subject_number)
  (value *= subject_number) % 20201227
end

def transform_subject_number(subject_number, loop_size)
  value = 1

  loop_size.times do
    value = execute_transformation_steps(value, subject_number)
  end

  value
end

def find_loop_size(subject_number, public_key)
  loop_size = 0
  value = 1

  while value != public_key
    value = execute_transformation_steps(value, subject_number)

    loop_size += 1
  end

  loop_size
end

def solve_part1(card_public_key, door_public_key)
  card_loop_size = find_loop_size(7, card_public_key)
  door_loop_size = find_loop_size(7, door_public_key)

  # transform_subject_number(door_public_key, card_loop_size) ==
  #   transform_subject_number(card_public_key, door_loop_size)

  transform_subject_number(door_public_key, card_loop_size)
end

# p solve_part1(card_public_key, door_public_key)
# p solve_part1(card_public_key, door_public_key) == 6198540
