grid = File.readlines("input").map { |l| l.chomp.split("") }

def right_neighbour(grid, x, y)
  if x == grid[y].size - 1
    return 0
  else
    return x + 1
  end
end

def bottom_neighbour(grid, x, y)
  if y == grid.size - 1
    return 0
  else
    return y + 1
  end
end

def do_step(grid)
  moved = false
  # ">" first
  temp_grid = Marshal.load(Marshal.dump(grid))
  grid.each_index do |y|
    grid[y].each_index do |x|
      next unless grid[y][x] == ">"
      new_x = right_neighbour(grid, x, y)
      if grid[y][new_x] == "."
        # make the move
        moved = true
        temp_grid[y][x], temp_grid[y][new_x] = temp_grid[y][new_x], temp_grid[y][x]
      end
    end
  end
  grid = temp_grid
  # "v" second
  temp_grid = Marshal.load(Marshal.dump(grid))
  grid.each_index do |y|
    grid[y].each_index do |x|
      next unless grid[y][x] == "v"
      new_y = bottom_neighbour(grid, x, y)
      if grid[new_y][x] == "."
        # make the move
        moved = true
        temp_grid[y][x], temp_grid[new_y][x] = temp_grid[new_y][x], temp_grid[y][x]
      end
    end
  end
  grid = temp_grid
  return grid, moved
end

# part 1
steps = 0
while true
  steps += 1
  grid, moved = do_step(grid)
  break unless moved
end
puts steps
