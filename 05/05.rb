# part 1 & 2
arr = File.readlines("input").map(&:chomp).map { |l| l.split(" -> ") }
coords1, coords2 = [], []
arr.each do |set|
  p1 = set[0].split(",").map &:to_i
  p2 = set[1].split(",").map &:to_i
  c = p1.zip(p2)
  if p1[0] == p2[0] or p1[1] == p2[1]
    (c[0].min..c[0].max).each do |x|
      (c[1].min..c[1].max).each do |y|
        coords1.push("#{x},#{y}")
        coords2.push("#{x},#{y}")
      end
    end
  else
    a = (p2[0] - p1[0]) / (p2[1] - p1[1])
    b = -a * p1[0] + p1[1]
    (c[0].min..c[0].max).each do |x|
      coords2.push("#{x},#{x * a + b}")
    end
  end
end
puts coords1.group_by { |i| i }.map { |k, v| v.count }.count { |v| v > 1 }
puts coords2.group_by { |i| i }.map { |k, v| v.count }.count { |v| v > 1 }
