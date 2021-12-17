# prepare ranges
line = File.read("input").chomp.split("")
line.shift(15)
line = line.join.split(", y=")
ranges = line.map { |r| r.split("..").map &:to_i }
x_range = (ranges[0].min..ranges[0].max)
y_range = (ranges[1].min..ranges[1].max)

# part 1 & 2
highest_y = 0
will_hit = 0
(0..ranges[0].max).each do |x|
  (ranges[1].min..ranges[1].min.abs).each do |y|
    dx, dy = x, y
    probe_max_y, xp, yp = 0, 0, 0
    hit = false
    while true
      # step
      xp += dx
      yp += dy
      dx -= 1 if dx > 0
      dx += 1 if dx < 0
      dy -= 1
      probe_max_y = yp if probe_max_y < yp
      if x_range.cover?(xp) && y_range.cover?(yp)
        hit = true
        will_hit += 1
        break
      end
      # check if the probe has overshot the target, stop searching if so
      break if dy < 0 && yp < ranges[1].min
    end
    highest_y = probe_max_y if probe_max_y > highest_y && hit
  end
end
puts highest_y
puts will_hit
