info = File.readlines("input").map(&:chomp)
dots = info[0...info.find_index("")].map { |d| x, y = d.split(","); [x.to_i, y.to_i] }
instructions = info[info.find_index("") + 1..-1].map { |i| d, a = i.split("="); [d[-1], a.to_i] }

def fold_left(dots, amount)
  folding = dots.filter { |d| d[0] > amount }
  folding.each do |d|
    dots.delete(d)
    new_x = amount - (d[0] - amount)
    dots.push([new_x, d[1]])
  end
  return dots
end

def fold_up(dots, amount)
  folding = dots.filter { |d| d[1] > amount }
  folding.each do |d|
    dots.delete(d)
    new_y = amount - (d[1] - amount)
    dots.push([d[0], new_y])
  end
  return dots
end

def plot_dots(dots)
  max_x, max_y = 0, 0
  dots.each { |d| x, y = d; max_x = [max_x, x].max; max_y = [max_y, y].max }
  graph = Array.new(max_y + 1) { Array.new(max_x + 1, " ") }
  dots.each { |d| graph[d[1]][d[0]] = "#" }
  graph.each { |row| puts row.join }
end

# part 1 & 2
instructions.each_with_index do |instruction, index|
  dir, amount = instruction
  dots = fold_left(dots, amount) if dir == "x"
  dots = fold_up(dots, amount) if dir == "y"
  # significantly improve execution time by removing duplicate dots
  dots = dots.uniq
  puts dots.size if index == 0
end
plot_dots(dots)
