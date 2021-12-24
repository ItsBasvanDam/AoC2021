# ===================== brute force (dumb, takes forever) =====================

# $program = File.readlines("input").map { |l| l.chomp.split(" ") }

# def resolve(var, register)
#   return register[var] if var == "w" || var == "x" || var == "y" || var == "z"
#   return var.to_i
# end

# def run(input)
#   register = Hash.new(0)
#   $program.each do |instruction, a, b|
#     case instruction
#     when "inp"
#       register[a] = input.shift
#     when "add"
#       register[a] += resolve(b, register)
#     when "mul"
#       register[a] *= resolve(b, register)
#     when "div"
#       register[a] /= resolve(b, register)
#     when "mod"
#       register[a] %= resolve(b, register)
#     when "eql"
#       register[a] = (register[a] == resolve(b, register)) ? 1 : 0
#     end
#   end
#   return register["z"] == 0
# end

# num = 99999999999999 # 14 nines
# while num >= 11111111111111 # 14 ones
#   input = num.to_s.chars
#   unless input.include?("0")
#     input.map! &:to_i
#     if run(input)
#       puts input.join
#       break
#     end
#   end
#   num -= 1
# end
# num = 11111111111111 # 14 ones
# while num <= 99999999999999 # 14 nines
#   input = num.to_s.chars
#   unless input.include?("0")
#     input.map! &:to_i
#     if run(input)
#       puts input.join
#       break
#     end
#   end
#   num += 1
# end

# ===================== linear time solution! =====================

# part 1 & 2
instructions = File.readlines("input").map &:chomp
value_stack = []
high_bound = 99999999999999 # 14 nines
low_bound = 11111111111111 # 14 ones

# for each digit index in the serial number
(0...14).each do |index|
  # grab each 18 lines as a part
  # line 6 variable from input
  a = instructions[(index * 18) + 5].split(" ").last.to_i
  # line 16 variable from input
  b = instructions[(index * 18) + 15].split(" ").last.to_i

  # if after the comparison (x == w) x becomes 1 (and gets flipped afterwards),
  # the value of z stays the same.
  if a > 0
    value_stack.push([b, index])
    next
  end

  b, prev_index = value_stack.pop
  # determine the exponent needed for decreasing the invalid digit
  exp_high = (a > -b) ? 13 - prev_index : 13 - index
  high_bound -= ((a + b) * 10 ** exp_high).abs
  # determine the exponent needed for increasing the invalid digit
  exp_low = (a < -b) ? 13 - prev_index : 13 - index
  low_bound += ((a + b) * 10 ** exp_low).abs
end

puts high_bound
puts low_bound
