# keep the numbers and depths as seperate lists
def prepare_line(line)
  depths = Hash.new 0
  chars = line.chars
  nums = eval(line).flatten
  depth_counter, counter, depth = 0, 0, 0
  while counter < chars.size
    num_added = false
    if line[counter] == "["
      depth += 1
    elsif line[counter] == "]"
      depth -= 1
    elsif line[counter].match(/\d/)
      loop do
        counter += 1
        break unless line[counter].match(/\d/)
      end
      depths[depth_counter] = depth
      depth_counter += 1
      num_added = true
    end
    counter += 1 unless num_added
  end
  return nums, depths.values
end

def add(nums, depths, nums_to_add, depths_to_add)
  nums += nums_to_add
  depths = depths.map { |d| d + 1 }
  depths_to_add = depths_to_add.map { |d| d + 1 }
  depths += depths_to_add
  return nums, depths
end

def explode_first(nums, depths)
  depths.each_with_index do |d, i|
    if d == 5 && depths[i + 1] == 5
      # this pair needs exploding
      left = nums.delete_at(i)
      right = nums[i]
      depths.delete_at(i)
      # overwrite one of the old numbers with 0
      nums[i] = 0
      depths[i] -= 1
      # shimmy the explosion left and right
      nums[i - 1] += left if i > 0
      nums[i + 1] += right if nums[i + 1] != nil
      # done
      return true
    end
  end
  return false
end

def split_first(nums, depths)
  nums.each_with_index do |n, i|
    if n >= 10
      # this number needs splitting
      left = (n / 2.0).floor
      right = (n / 2.0).ceil
      nums[i] = left
      depths[i] += 1
      nums.insert(i + 1, right)
      depths.insert(i + 1, depths[i])
      # done
      return true
    end
  end
  return false
end

def reduce_num(nums, depths)
  while true
    next if explode_first(nums, depths)
    break unless split_first(nums, depths)
  end
end

def compute_magnitude(nums, depths)
  while nums.size > 1
    for i in 1...nums.size
      if depths[i - 1] == depths[i]
        # magnitude computation
        nums[i - 1] = nums[i - 1] * 3 + nums[i] * 2
        nums.delete_at(i)
        depths.delete_at(i)
        depths[i - 1] -= 1
        break
      end
    end
  end
  return nums[0]
end

lines = File.readlines("input").map &:chomp

# part 1
result_nums, result_depths = prepare_line(lines[0])
(1...lines.size).each do |i|
  n, d = prepare_line(lines[i])
  result_nums, result_depths = add(result_nums, result_depths, n, d)
  reduce_num(result_nums, result_depths)
end
puts compute_magnitude(result_nums, result_depths)

# part 2
largest_magnitude = 0
lines.each do |l1|
  lines.each do |l2|
    unless l1 == l2
      n1, d1 = prepare_line(l1)
      n2, d2 = prepare_line(l2)
      result_nums, result_depths = add(n1, d1, n2, d2)
      reduce_num(result_nums, result_depths)
      result = compute_magnitude(result_nums, result_depths)
      largest_magnitude = result if result > largest_magnitude
    end
  end
end
puts largest_magnitude
