def get_neighbours(length, node)
  x, y = node
  yield [x - 1, y] if x > 0
  yield [x + 1, y] if x < length - 1
  yield [x, y - 1] if y > 0
  yield [x, y + 1] if y < length - 1
end

def find_shortest_path(grid)
  l = grid.size
  dists = Array.new(l) { Array.new(l, Float::INFINITY) }
  # walk the graph from finish (bottom-right) to start (top-left)
  dists[l - 1][l - 1] = grid[l - 1][l - 1]
  queue = []
  queue.unshift([l - 1, l - 1])
  until queue.empty?
    m, n = queue.pop
    get_neighbours(l, [m, n]) do |neighbour|
      c = 0
      x, y = neighbour
      # do not count the startnode's weight
      unless neighbour == [0, 0]
        c = grid[y][x]
      end
      # relax neighbour edges if a shorter path is found
      if dists[y][x] > dists[n][m] + c
        dists[y][x] = dists[n][m] + c
        queue.unshift([x, y])
      end
    end
  end
  return dists[0][0]
end

grid = File.readlines("input").map { |l| l.chomp.split("").map(&:to_i) }

# part 1
puts find_shortest_path(grid)

# part 2
# width
grid.map! do |row|
  orig = row.dup
  4.times { row += orig.map! { |v| (v % 9) + 1 } }
  row
end
# height
grid_orig = grid.dup
4.times do
  grid += grid_orig.map! { |r| r.map { |c| (c % 9) + 1 } }
end
puts find_shortest_path(grid)
