lines = File.readlines("input").map { |l| l.split(" | ").map { |lp| lp.chomp.split(" ") } }

# part 1
total = 0
lines.each do |l|
  total += l[1].count { |s| [2, 3, 4, 7].include?(s.size) }
end
puts total

# part 2
def decode_digit(digit, input)
  case digit.size
  when 2
    return "1"
  when 3
    return "7"
  when 4
    return "4"
  when 7
    return "8"
  when 5
    # 2, 3 & 5
    seven = input.find { |i| i.size == 3 }.split("")
    four = input.find { |i| i.size == 4 }.split("")
    if (digit.split("").sort - seven.sort).size == 2
      return "3"
    elsif (digit.split("").sort - four.sort).size == 3
      return "2"
    else
      return "5"
    end
  when 6
    # 6, 9 & 0
    one = input.find { |i| i.size == 2 }.split("")
    four = input.find { |i| i.size == 4 }.split("")
    if (digit.split("") - one).size == 5
      return "6"
    elsif (digit.split("") - four).size == 2
      return "9"
    else
      return "0"
    end
  else
    throw "not supported: #{digit}"
  end
end

total = []
lines.each do |l|
  output = ""
  l[1].each do |op|
    output += decode_digit(op, l[0])
  end
  total.push(output.to_i)
end
puts total.reduce :+
