example_inputs = %w[
  8A004A801A8002F478
  620080001611562C8802118E34
  C0015000016115A2E0802F182340
  A0016C880162017C3686B18A3D4780
]
input = File.read("16.input.txt").chomp

def hexadecimal_to_binary(hexadecimal)
  hexadecimal.to_i(16).to_s(2).rjust(hexadecimal.length * 4, "0")
end

def decode_packet(bits, start_position)
  current_position = start_position

  version = bits[current_position, 3].to_i(2)
  current_position += 3

  type_id = bits[current_position, 3].to_i(2)
  current_position += 3

  if type_id == 4
    end_of_packet = false
    number_bits = ""

    until end_of_packet
      end_of_packet = bits[current_position, 1].to_i(2).zero?
      current_position += 1
      number_bits += bits[current_position, 4]
      current_position += 4
    end

    {
      version: version,
      type_id: type_id,
      value: number_bits.to_i(2),
      length_in_bits: current_position - start_position,
      start_position: start_position,
      end_position: current_position - 1
    }
  else
    length_type_id = bits[current_position, 1].to_i(2)
    current_position += 1

    case length_type_id
    when 0
      length_in_bits = bits[current_position, 15].to_i(2)
      current_position += 15
      subpackets_start_position = current_position

      subpackets = []
      while current_position - subpackets_start_position != length_in_bits
        packet = decode_packet(bits, current_position)
        current_position += packet[:length_in_bits]
        subpackets << packet
      end

      {
        version: version,
        type_id: type_id,
        subpackets: subpackets,
        length_in_bits: current_position - start_position,
        start_position: start_position,
        end_position: current_position - 1
      }
    when 1
      number_of_subpackets = bits[current_position, 11].to_i(2)
      current_position += 11

      subpackets = []
      while subpackets.count != number_of_subpackets
        packet = decode_packet(bits, current_position)
        current_position += packet[:length_in_bits]
        subpackets << packet
      end

      {
        version: version,
        type_id: type_id,
        subpackets: subpackets,
        length_in_bits: current_position - start_position,
        start_position: start_position,
        end_position: current_position - 1
      }
    end
  end
end

def decode_transmission(hexadecimal_representation)
  binary_representation = hexadecimal_to_binary(hexadecimal_representation)
  decode_packet(binary_representation, 0)
end

# === part 1

def add_version_numbers(packet)
  if packet[:type_id] == 4
    packet[:version]
  else
    packet[:version] +
      packet[:subpackets].sum do |subpacket|
        add_version_numbers(subpacket)
      end
  end
end

p add_version_numbers(decode_transmission(input))
# => 963

# === part 2

def evaluate(packet)
  return packet[:value] if packet[:type_id] == 4

  values_of_subpackets = packet[:subpackets].map { |p| evaluate(p) }

  case packet[:type_id]
  when 0 then values_of_subpackets.sum
  when 1 then values_of_subpackets.reduce(:*)
  when 2 then values_of_subpackets.min
  when 3 then values_of_subpackets.max
  when 5 then values_of_subpackets.reduce(:>) ? 1 : 0
  when 6 then values_of_subpackets.reduce(:<) ? 1 : 0
  when 7 then values_of_subpackets.reduce(:==) ? 1 : 0
  end
end

p evaluate(decode_transmission(input))
# => 1549026292886
