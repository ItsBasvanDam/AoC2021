arr = File.read("input").split(",").map &:to_i

# part 1
nums = []
(0...arr.max).each do |pos|
  nums[pos] = arr.map { |c| (pos - c).abs }.reduce :+
end
puts nums.min

# part 2
nums = []
(0...arr.max).each do |pos|
  nums[pos] = arr.map { |c| (pos - c).abs * ((pos - c).abs + 1) / 2 }.reduce :+
end
puts nums.min
