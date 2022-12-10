datastream_buffer = File.read("06.input.txt").chomp

def solve(datastream_buffer, marker_length)
  i = 0

  until datastream_buffer[i, marker_length].chars.uniq.count == marker_length
    i += 1
  end

  i + marker_length
end

p solve(datastream_buffer, 4)
# => 1855

p solve(datastream_buffer, 14)
# => 3256
