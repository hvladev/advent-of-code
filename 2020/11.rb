input = File.readlines("11.input.txt", chomp: true).map(&:chars)

# === part 1

def seat_state_at(row, column, input)
  return nil if row < 0 || row >= input.size
  return nil if column < 0 || column >= input[row].size

  input[row][column]
end

def next_seat_state(row, column, input)
  current_state = input[row][column]
  adjacent_seats = [
    seat_state_at(row - 1, column - 1, input),
    seat_state_at(row - 1, column    , input),
    seat_state_at(row - 1, column + 1, input),
    seat_state_at(row    , column - 1, input),
    seat_state_at(row    , column + 1, input),
    seat_state_at(row + 1, column - 1, input),
    seat_state_at(row + 1, column    , input),
    seat_state_at(row + 1, column + 1, input),
  ].compact

  if current_state == "L" && !adjacent_seats.include?("#")
    "#"
  elsif current_state == "#" && adjacent_seats.count("#") >= 4
    "L"
  else
    current_state
  end
end

def next_layout_state(input)
  input.map.with_index do |columns, row|
    columns.map.with_index do |seat, column|
      next_seat_state(row, column, input)
    end
  end
end

def solve_part1(input)
  current_layout_state = input

  loop do
    next_state = next_layout_state(current_layout_state)

    if current_layout_state == next_state
      break
    else
      current_layout_state = next_state
    end
  end

  current_layout_state.flatten.count("#")
end

# p solve_part1(input)
# => 2359


# === part 2

def visible_seats_from(row, column, input)
  directions = {
    nw: :todo,
    n:  :todo,
    ne: :todo,
    w:  :todo,
    e:  :todo,
    sw: :todo,
    s:  :todo,
    se: :todo,
  }
  radius = 1

  loop do
    break unless directions.values.include?(:todo)

    nw = seat_state_at(row - radius, column - radius, input)
    n  = seat_state_at(row - radius, column         , input)
    ne = seat_state_at(row - radius, column + radius, input)
    w  = seat_state_at(row         , column - radius, input)
    e  = seat_state_at(row         , column + radius, input)
    sw = seat_state_at(row + radius, column - radius, input)
    s  = seat_state_at(row + radius, column         , input)
    se = seat_state_at(row + radius, column + radius, input)

    directions[:nw] = nw if directions[:nw] == :todo && nw != "."
    directions[:n]  = n  if directions[:n]  == :todo && n  != "."
    directions[:ne] = ne if directions[:ne] == :todo && ne != "."
    directions[:w]  = w  if directions[:w]  == :todo && w  != "."
    directions[:e]  = e  if directions[:e]  == :todo && e  != "."
    directions[:sw] = sw if directions[:sw] == :todo && sw != "."
    directions[:s]  = s  if directions[:s]  == :todo && s  != "."
    directions[:se] = se if directions[:se] == :todo && se != "."

    radius += 1
  end

  directions.values.compact
end

def next_seat_state(row, column, input)
  current_state = input[row][column]
  visible_seats = visible_seats_from(row, column, input)

  if current_state == "L" && !visible_seats.include?("#")
    "#"
  elsif current_state == "#" && visible_seats.count("#") >= 5
    "L"
  else
    current_state
  end
end

def solve_part2(input)
  solve_part1(input)
end

# p solve_part2(input)
# => 2131
