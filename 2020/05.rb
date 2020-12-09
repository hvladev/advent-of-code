input = File.readlines("05.input.txt", chomp: true)

# === part 1

def find_row(boarding_pass)
  low, high = [0, 127]

  (0..6).each do |x|
    middle = (low + high) / 2
    low, high = boarding_pass[x] == "F" ? [low, middle] : [middle + 1, high]
    # p "#{x} - #{[low, high].inspect}"
  end

  # [low, high]
  low
end

def find_column(boarding_pass)
  low, high = [0, 7]

  (7..9).each do |x|
    middle = (low + high) / 2
    low, high = boarding_pass[x] == "L" ? [low, middle] : [middle + 1, high]
    # p "#{x} - #{[low, high].inspect}"
  end

  # [low, high]
  low
end

def seat_id(boarding_pass)
  (find_row(boarding_pass) * 8) + find_column(boarding_pass)
end

def highest_seat_id(boarding_passes)
  highest_id = 0

  boarding_passes.each do |boarding_pass|
    id = seat_id(boarding_pass)

    highest_id = id if id > highest_id
  end

  highest_id
end

highest_seat_id(input)
# => 935



# === part 2

seat = nil

input.map { |boarding_pass| seat_id(boarding_pass) }.sort!.each_cons(2) do |(a, b)|
  if b - a > 1
    seat = b - 1
    break
  end
end

seat
# => 743
