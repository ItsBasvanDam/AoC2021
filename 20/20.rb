def enhance_edge(edge, algorithm)
  return (algorithm[0] == 0) ? 0 : 1 if edge == 0
  return (algorithm[-1] == 1) ? 1 : 0
end

def pixel_to_decimal(img, x, y)
  binary = ""
  (-1..1).each do |dy|
    (-1..1).each do |dx|
      xt = x + dx
      yt = y + dy
      if yt >= 0 && yt < img.size && xt >= 0 && xt < img[yt].size
        binary += img[y + dy][x + dx].to_s
      else
        binary += $default_edge.to_s
      end
    end
  end
  return binary.to_i(2)
end

def enhance_img(img, algorithm)
  new_img = []
  (-1...img.size + 1).each do |y|
    new_row = []
    (-1...img[0].size + 1).each do |x|
      new_row.push(algorithm[pixel_to_decimal(img, x, y)])
    end
    new_img.push(new_row)
  end
  $default_edge = enhance_edge($default_edge, algorithm)
  return new_img
end

$default_edge = 0
lines = File.readlines("input").map &:chomp
algorithm = lines.shift.split("").map { |c| c == "#" ? 1 : 0 }
lines.shift

# part 1 & 2
[2, 50].each do |n|
  img = lines.map { |l| l.split("").map { |c| c == "#" ? 1 : 0 } }
  n.times do
    img = enhance_img(img, algorithm)
  end
  on = 0
  img.each { |row| on += row.count(1) }
  puts on
end
