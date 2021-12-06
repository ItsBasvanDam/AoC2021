orig = File.read("input").split(",").map &:to_i

# part 1
arr = orig.dup
(1..80).each do |day|
  to_add = arr.count { |f| f == 0 }
  arr.map! { |f| f == 0 ? 6 : f - 1 }
  arr = arr + Array.new(to_add, 8)
end
puts arr.size

# part 2
counts = Array.new(9, 0)
orig.each do |o|
  counts[o] += 1
end
(1..256).each do |day|
  to_add = counts[0]
  counts.shift
  counts[6] += to_add
  counts[8] = to_add
end
puts counts.reduce :+
