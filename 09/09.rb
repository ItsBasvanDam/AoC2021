arr = File.readlines("input").map do |l|
  l.chomp.split("").map &:to_i
end

# part 1
points = []
(0...arr.size).each do |y|
  (0...arr[y].size).each do |x|
    val = arr[y][x]
    next if y > 0 && val >= arr[y - 1][x]
    next if y < arr.size - 1 && val >= arr[y + 1][x]
    next if x > 0 && val >= arr[y][x - 1]
    next if x < arr[y].size - 1 && val >= arr[y][x + 1]
    points.push([x, y, val])
  end
end
puts points.map { |i| arr[i[1]][i[0]] }.reduce(:+) + points.size

# part 2
def fill_basin_recurse(basin, a, x, y, covered)
  return if covered.has_key?([y, x])
  covered[[y, x]] = 0
  return if a[y][x] == 9
  if y > 0
    fill_basin_recurse(basin, a, x, y - 1, covered)
  end
  if y < a.size - 1
    fill_basin_recurse(basin, a, x, y + 1, covered)
  end
  if x > 0
    fill_basin_recurse(basin, a, x - 1, y, covered)
  end
  if x < a[y].size - 1
    fill_basin_recurse(basin, a, x + 1, y, covered)
  end
  basin.push([a[y][x], y, x])
end

# use Hash for covered list, since has_key? operates at O(1) speed
covered = Hash.new
basins = []
x, y = 0, 0
(0...arr.size).each do |yc|
  y = yc
  (0...arr[yc].size).each do |xc|
    x = xc
    basin = []
    fill_basin_recurse(basin, arr, x, y, covered)
    if basin.size > 0 && !basins.any? { |b| (b - basin).empty? }
      basins.push(basin)
    end
  end
end
puts basins.map(&:size).max(3).reduce :*
