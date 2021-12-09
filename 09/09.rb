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
def fill_basin_recurse(basin, a, x, y, covered = [])
  return if covered.include?([y, x])
  covered.push([y, x])
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

basins = []
x, y = 0, 0
# floodfill the entire board, brute force style
# could be optimized by skipping the points which are already part of a discovered basin
(0...arr.size).each do |yc|
  y = yc
  (0...arr[yc].size).each do |xc|
    x = xc
    basin = []
    fill_basin_recurse(basin, arr, x, y)
    if basin.size > 0 && !basins.any? { |b| (b - basin).empty? }
      basins.push(basin)
    end
  end
end
puts basins.map(&:size).max(3).reduce :*
