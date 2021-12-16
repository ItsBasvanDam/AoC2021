bin = File.read("input").split("").map { |s| s.hex.to_s(2).rjust(s.size * 4, "0") }.join.split("")

def handle_subs(bin)
  outcomes = []
  length_type_id = bin.shift(1)[0]
  if length_type_id == "1"
    # handle a number of sub-packets
    sub_packets = bin.shift(11).join.to_i(2)
    sub_packets.times do
      outcomes.push(handle_packets_recurse(bin))
    end
  else
    # handle a number of bits as sub-packets
    length_in_bits = bin.shift(15).join.to_i(2)
    orig_len = bin.size
    while true
      outcomes.push(handle_packets_recurse(bin))
      break if bin.size <= orig_len - length_in_bits
    end
  end
  return outcomes
end

def handle_packets_recurse(bin)
  version = bin.shift(3).join.to_i(2)
  $version_sum += version
  type_id = bin.shift(3).join.to_i(2)

  case type_id
  when 0 then return handle_subs(bin).reduce :+
  when 1 then return handle_subs(bin).reduce :*
  when 2 then return handle_subs(bin).min
  when 3 then return handle_subs(bin).max
  when 4
    result = ""
    # packet is a literal value
    while true
      last_packet = bin.shift == "0"
      result << bin.shift(4).join
      if last_packet
        return result.to_i(2)
      end
    end
  when 5 then f, s = handle_subs(bin); return f > s ? 1 : 0
  when 6 then f, s = handle_subs(bin); return f < s ? 1 : 0
  when 7 then f, s = handle_subs(bin); return f == s ? 1 : 0
  end
end

# part 1 & 2
$version_sum = 0
result = handle_packets_recurse(bin)
puts $version_sum
puts result
