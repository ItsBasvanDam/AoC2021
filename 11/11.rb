arr = File.readlines("input").map(&:chomp).map { |l| l.split("").map &:to_i }

# part 1 & 2
def do_the_wave(a, y, x)
  if x > 0
    a[y][x - 1] += 1
    if y > 0 then a[y - 1][x - 1] += 1 end
    if y < a.size - 1 then a[y + 1][x - 1] += 1 end
  end
  if x < a[y].size - 1
    a[y][x + 1] += 1
    if y > 0 then a[y - 1][x + 1] += 1 end
    if y < a.size - 1 then a[y + 1][x + 1] += 1 end
  end
  if y > 0 then a[y - 1][x] += 1 end
  if y < a.size - 1 then a[y + 1][x] += 1 end
end

def flash_all(a, flashed)
  flash = false
  a.each_index do |y|
    a[y].each_index do |x|
      if !flashed.include?([y, x]) && a[y][x] > 9
        flashed.push([y, x])
        do_the_wave(a, y, x)
        flash = true
      end
    end
  end
  return flash
end

total_flashes = 0
counter = 0
while true
  counter += 1
  # increment all octopi by 1
  arr = arr.map { |r| r.map { |c| c += 1 } }
  # flash them!
  flashed = []
  flash = true
  flash = flash_all(arr, flashed) while flash
  # reset them to 0 if flashed
  flashed.each { |c| y, x = c; arr[y][x] = 0 }

  total_flashes += flashed.size
  puts "part 1: #{total_flashes}" if counter == 100
  if flashed.size == arr.flatten.size
    puts "part 2: #{counter}"
    return
  end
end
