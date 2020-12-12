input = File.readlines("12.input.txt", chomp: true)

# === part 1

def solve_part1(input)
  directions = {
    0 => "N",
    90 => "E",
    180 => "S",
    270 => "W",
  }
  ship = {
    direction: 90, # east, 0 - north, 180 - south, 270 - west
    east: 0,
    north: 0,
  }

  input.each do |foo|
    action = foo[0]
    value = foo[1..-1].to_i

    case action
    when "L"
      ship[:direction] = (ship[:direction] - value) % 360
    when "R"
      ship[:direction] = (ship[:direction] + value) % 360
    when "S"
      ship[:north] -= value
    when "N"
      ship[:north] += value
    when "W"
      ship[:east] -= value
    when "E"
      ship[:east] += value
    when "F"
      case directions[ship[:direction]]
      when "S"
        ship[:north] -= value
      when "N"
        ship[:north] += value
      when "W"
        ship[:east] -= value
      when "E"
        ship[:east] += value
      end
    end
  end

  ship[:east].abs + ship[:north].abs
end

# p solve_part1(input)
# => 1186


# === part 2

def sign(waypoint)
  case waypoint[:quadrant]
  when 0 then {east: +1, north: +1}
  when 1 then {east: +1, north: -1}
  when 2 then {east: -1, north: -1}
  when 3 then {east: -1, north: +1}
  else
    raise "WTF"
  end
end

def solve_part2(input)
  waypoint = {
    quadrant: 0,
    east: 10,
    north: 1,
  }
  ship = { east: 0, north: 0 }

  input.each do |foo|
    action = foo[0]
    value = foo[1..-1].to_i

    case action
    when "L"
      case value
      when 90
        waypoint[:quadrant] = (waypoint[:quadrant] - 1) % 4
        waypoint[:east], waypoint[:north] = waypoint[:north], waypoint[:east]
      when 180
        waypoint[:quadrant] = (waypoint[:quadrant] - 2) % 4
      when 270
        waypoint[:quadrant] = (waypoint[:quadrant] - 3) % 4
        waypoint[:east], waypoint[:north] = waypoint[:north], waypoint[:east]
      else
        raise "OMG"
      end
    when "R"
      case value
      when 90
        waypoint[:quadrant] = (waypoint[:quadrant] + 1) % 4
        waypoint[:east], waypoint[:north] = waypoint[:north], waypoint[:east]
      when 180
        waypoint[:quadrant] = (waypoint[:quadrant] + 2) % 4
      when 270
        waypoint[:quadrant] = (waypoint[:quadrant] + 3) % 4
        waypoint[:east], waypoint[:north] = waypoint[:north], waypoint[:east]
      else
        raise "OMG"
      end
    when "S"
      n = waypoint[:north] * sign(waypoint)[:north] - value

      if n < 0 && waypoint[:quadrant] == 3
        waypoint[:quadrant] = 2
      end
      if n < 0 && waypoint[:quadrant] == 0
        waypoint[:quadrant] = 1
      end

      waypoint[:north] = n.abs
    when "N"
      n = waypoint[:north] * sign(waypoint)[:north] + value

      if n > 0 && waypoint[:quadrant] == 2
        waypoint[:quadrant] = 3
      end
      if n > 0 && waypoint[:quadrant] == 1
        waypoint[:quadrant] = 0
      end

      waypoint[:north] = n.abs
    when "W"
      n = waypoint[:east] * sign(waypoint)[:east] - value

      if n < 0 && waypoint[:quadrant] == 0
        waypoint[:quadrant] = 3
      end
      if n < 0 && waypoint[:quadrant] == 1
        waypoint[:quadrant] = 2
      end

      waypoint[:east] = n.abs
    when "E"
      n = waypoint[:east] * sign(waypoint)[:east] + value

      if n > 0 && waypoint[:quadrant] == 3
        waypoint[:quadrant] = 0
      end
      if n > 0 && waypoint[:quadrant] == 2
        waypoint[:quadrant] = 1
      end

      waypoint[:east] = n.abs
    when "F"
      ship[:east] += waypoint[:east] * value * sign(waypoint)[:east]
      ship[:north] += waypoint[:north] * value * sign(waypoint)[:north]
    end
  end

  p waypoint
  p ship
  ship[:east].abs + ship[:north].abs
end

# p solve_part2(input)
# => 47806
