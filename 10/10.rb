arr = File.readlines("input").map &:chomp
brackets = { "(" => ")", ")" => "(", "[" => "]", "]" => "[", "{" => "}", "}" => "{", "<" => ">", ">" => "<" }
points_1 = { ")" => 3, "]" => 57, "}" => 1197, ">" => 25137 }
points_2 = { ")" => 1, "]" => 2, "}" => 3, ">" => 4 }

# part 1 & 2
corrupted = []
missing = []
arr.each do |line|
  stack = []
  chars = line.split("")
  chars.each_index do |i|
    c = chars[i]
    if ["(", "[", "{", "<"].include?(c)
      stack.push(c)
    else
      cc = stack.pop()
      if c != brackets[cc]
        corrupted.push(c)
        break
      end
    end
    missing.push(stack) if i == chars.size - 1
  end
end
puts corrupted.map { |c| points_1[c] }.reduce :+
puts missing.map { |l| l.map { |c| brackets[c] }.reverse }.map { |l| l.map { |c| points_2[c] }.reduce { |pr, c| (pr * 5) + c } }.sort[(missing.size - 1) / 2]
