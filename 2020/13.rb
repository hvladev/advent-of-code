input = File.readlines("13.input.txt", chomp: true)

estimate = input[0].to_i
bus_ids = input[1].split(",").reject { |id| id == "x" }.map(&:to_i)

# === part 1

def solve_part1(input)
  estimate = input[0].to_i
  bus_ids = input[1].split(",").reject { |id| id == "x" }.map(&:to_i)

  # estimate = 939
  # bus_ids = [7,13,59,31,19]

  depart_times = bus_ids.map do |id|
    depart_time = 0

    while depart_time < estimate do
      depart_time += id
    end

    depart_time
  end

  waiting_times = depart_times.map { |t| t - estimate }

  waiting_time, bus_id = waiting_times.zip(bus_ids).min_by(&:first)

  waiting_time * bus_id
end

p solve_part1(input)
# => 161

# === part 2

# First bus in the list leaves at intervals of 29 (aka the bus ID)
#
# Next bus in the list is "x" which means we don't care about it, but we should
# consider the minutes for the next non "x" bus in the list
#
# Skip some "x" values and we get to bus ID 41.
# It should depart 19 mins after bus ID 29.
#
# Here's an equation for that:
#
# 29a + 19 = 41b, where 29a is a departure timestamp for bus ID 29
#                       41b is a departure timestamp for bus ID 41 which is exactly 19 mins after bus ID 29
#                       a is number of departures for bus ID 29 to get the timestamp
#                       b is number of departures for bus ID 41 to get the timestamp
#
# Using the same logic here are the rest of the equations:
#
# 29a + 19 = 41b
# 29a + 29 = 661c
# 29a + 42 = 13d
# 29a + 43 = 17x
# 29a + 52 = 23y
# 29a + 60 = 521z
# 29a + 66 = 37k
# 29a + 79 = 19j
#
# Now we need a solution for a system of equations.
# Go to http://wolframalpha.com and find the solution for:
#
# ( 29a + 19 = 41b ) and
# ( 29a + 29 = 661c ) and
# ( 29a + 42 = 13d ) and
# ( 29a + 43 = 17x ) and
# ( 29a + 52 = 23y ) and
# ( 29a + 60 = 521z ) and
# ( 29a + 66 = 37k ) and
# ( 29a + 79 = 19j )
#
# Solution:
#
# a = 50454333580729 * n + 7375539042442
# b = 35687211557101 * n + 5216844688557
# c = 2213578931681 * n + 323586433027
# d = 112551974910857 * n + 16453125556220
# j = 77009245991639 * n + 11257401696363
# k = 39545288482193 * n + 5780827898132
# x = 86069157284773 * n + 12581801895933
# y = 63616333645267 * n + 9299592705690
# z = 2808398606221 * n + 410538641518
# , where n belongs to Z
#
# Obviously, the desired configuration of offsets happens over and over again.
# For the earliest timestamp, take n = 0 and the value of "a", ie:
#
# a = 50454333580729 * n + 7375539042442
# a = 50454333580729 * 0 + 7375539042442
# a = 7375539042442
#
# This means after 7375539042442 departures of the first bus in the list (bus
# ID: 29) we get earliest timestamp for to desired configuration.
#
# Bus ID: 29
# Number of departures from the sea port: 7375539042442 (value of "a" when n = 0)
# Earliest timestamp: 213890632230818 = 29 * 7375539042442
#
# => 213890632230818
